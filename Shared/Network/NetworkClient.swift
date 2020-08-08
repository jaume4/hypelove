//
//  NetworkClient.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//  Copyright © 2020 Jaume. All rights reserved.
//

import Foundation
import Combine

final class NetworkClient {
    
    static let shared = NetworkClient()
    
    private let baseURL = URL(string: "https://api.hypem.com")!
    private let version = "v2"
    private let session: URLSession
    
    let decoder = JSONDecoder()
    let encoder = JSONDecoder()
    
    private var loginPublisher: AnyPublisher<LoginRequest.Response, NetworkError<LoginRequest.CustomError>>?
    private var currentCancellables: Set<AnyCancellable> = []
    
    @Published var token: String?
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = .shared
        configuration.requestCachePolicy = .reloadRevalidatingCacheData
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 120
        session = URLSession(configuration: configuration)
    }
    
    private func makeURL<T: NetworkRequest>(_ request: T) -> URL {
        return baseURL
            .appendingPathComponent(version)
            .appendingPathComponent(request.endPoint)
    }
    
    func sendRequest<T: NetworkFormRequest>(_ request: T) -> AnyPublisher<T.Response, NetworkError<T.CustomError>> {
        var urlRequest = makeBaseRequest(request)
        urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let formBody = request.params.reduce("", { $0 + $1.key + "=" + $1.value + "&" })
        urlRequest.httpBody = Data(formBody.utf8)
        return sendRequest(request, urlRequest: urlRequest)
    }
    
    private func makeBaseRequest<T: NetworkRequest>(_ request: T) -> URLRequest {
        var urlRequest = URLRequest(url: makeURL(request))
        urlRequest.httpMethod = request.method.rawValue
        return urlRequest
    }
    
    private func resendRequest<T: NetworkRequest>(_ request: T) -> AnyPublisher<T.Response, NetworkError<T.CustomError>> {
        
        let promise = Future<T.Response, NetworkError<T.CustomError>>  { promise in
            
            let loginPublisher: AnyPublisher<LoginRequest.Response, NetworkError<LoginRequest.CustomError>>
            
            if let currentPublisher = self.loginPublisher {
                loginPublisher = currentPublisher
            } else {
                let loginRequest = LoginRequest(userName: "", password: "", deviceID: "")
                let urlRequest = self.makeBaseRequest(loginRequest)
                loginPublisher = self.sendRequest(loginRequest, urlRequest: urlRequest).share().eraseToAnyPublisher()
                self.loginPublisher = loginPublisher.eraseToAnyPublisher()
            }

            loginPublisher
                .sink { (error) in
                    promise(.failure(NetworkError<T.CustomError>.notAuthorized))
                } receiveValue: { (response) in
                    self.token = response.hmToken
                    self.sendRequest(request, urlRequest: self.makeBaseRequest(request))
                        .sink { completion in
                            switch completion {
                            
                            case .finished: return
                            case .failure(let error): promise(.failure(error))
                            }
                        } receiveValue: { response in
                            promise(.success(response))
                        }.store(in: &self.currentCancellables)

                }.store(in: &self.currentCancellables)
        }
        
        return promise.eraseToAnyPublisher()
    }
    
    private func sendRequest<T: NetworkRequest>(_ request: T, urlRequest: URLRequest) -> AnyPublisher<T.Response, NetworkError<T.CustomError>> {
        
        var retrying = false
        let requestPublisher = session.dataTaskPublisher(for: urlRequest)
        
        return requestPublisher
            .receive(on: DispatchQueue.global())
            .subscribe(on: DispatchQueue.global())
            .tryMap { data, response in
                try request.transformResponse(data: data, response: response)
            }
            .mapError { error -> NetworkError<T.CustomError> in
                return (error as? NetworkError<T.CustomError>) ?? NetworkError<T.CustomError>.unknown
            }
            .tryCatch{ (error) throws -> AnyPublisher<T.Response, NetworkError<T.CustomError>> in
                guard !retrying && !(request is LoginRequest) else { throw error }
                retrying = true
                guard error == NetworkError<T.CustomError>.notAuthorized else { throw error }
                return self.resendRequest(request)
            }
            .mapError{ error in
                return (error as? NetworkError<T.CustomError>) ?? NetworkError<T.CustomError>.unknown
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
