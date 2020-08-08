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
    
    private let host = "api.hypem.com"
//    private let host = "192.168.1.2"
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
        decoder.dateDecodingStrategy = .secondsSince1970
        #if !DEBUG
        session = URLSession(configuration: configuration)
        #else
        session = URLSession(configuration: configuration, delegate: SessionDelegate(), delegateQueue: nil)
        #endif
    }
    
    private func makeURL<T: NetworkRequest>(_ request: T) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/" + version + "/" + request.endPoint
        components.queryItems = request.urlParams.map(URLQueryItem.init)
        return components.url!
    }
    
    func send<T: NetworkRequest>(_ request: T) -> AnyPublisher<T.Response, NetworkError<T.CustomError>> {
        let urlRequest = makeBaseURLRequest(request)
        return send(request, urlRequest: urlRequest)
    }
    
    func send<T: NetworkFormRequest>(_ request: T) -> AnyPublisher<T.Response, NetworkError<T.CustomError>> {
        var urlRequest = makeBaseURLRequest(request)
        urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let formBody = request.params.reduce("", { $0 + $1.key + "=" + $1.value + "&" })
        urlRequest.httpBody = Data(formBody.utf8)
        return send(request, urlRequest: urlRequest)
    }
    
    private func makeBaseURLRequest<T: NetworkRequest>(_ request: T) -> URLRequest {
        var urlRequest = URLRequest(url: makeURL(request))
        urlRequest.httpMethod = request.method.rawValue
        return urlRequest
    }
    
    /// Retries the given request attemting to login first
    /// - Parameter request: Request to retry
    /// - Returns: Future that fullfills after login attempt is finished and request is resent, or on login error
    private func resendRequest<T: NetworkRequest>(_ request: T) -> AnyPublisher<T.Response, NetworkError<T.CustomError>> {
        
        let promise = Future<T.Response, NetworkError<T.CustomError>>  { promise in
            
            let loginPublisher: AnyPublisher<LoginRequest.Response, NetworkError<LoginRequest.CustomError>>
            
            if let currentPublisher = self.loginPublisher {
                loginPublisher = currentPublisher
            } else {
                #warning("fix data")
                let loginRequest = LoginRequest(userName: "", password: "", deviceID: "")
                let urlRequest = self.makeBaseURLRequest(loginRequest)
                loginPublisher = self.send(loginRequest, urlRequest: urlRequest).share().eraseToAnyPublisher()
                self.loginPublisher = loginPublisher.eraseToAnyPublisher()
            }

            loginPublisher
                .sink { completion in
                    switch completion {
                    case .finished: return
                    case .failure(_): promise(.failure(NetworkError<T.CustomError>.notAuthorized))
                    }
                } receiveValue: { (response) in
                    //Succeeded refresh, resend request regenerating urlRequest as token has changed
                    self.token = response.hmToken
                    self.send(request, urlRequest: self.makeBaseURLRequest(request))
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
    
    /// Sends any NetworkRequest and retries it if an error is given and [shouldRetry](x-source-tag://ShouldRetry) returns true
    private func send<T: NetworkRequest>(_ request: T, urlRequest: URLRequest) -> AnyPublisher<T.Response, NetworkError<T.CustomError>> {
        
        var retrying = false
        let requestPublisher = session.dataTaskPublisher(for: urlRequest)
        
        return requestPublisher
            .receive(on: DispatchQueue.global())
            .subscribe(on: DispatchQueue.global())
            .tryMap { data, response in
                try request.transformResponse(data: data, response: response)
            }
            .mapError { error -> NetworkError<T.CustomError> in
                (error as? NetworkError<T.CustomError>) ?? NetworkError<T.CustomError>.unknown
            }
            .tryCatch{ (error) throws -> AnyPublisher<T.Response, NetworkError<T.CustomError>> in
                guard !retrying, self.shouldRetry(request: request, error: error) else { throw error }
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
    
    /// Logic for retrying requests. Login request or custom errors are not retried, not authorized and everything else gets retried.
    /// - Tag: ShouldRetry
    private func shouldRetry<T: NetworkRequest>(request: T, error: NetworkError<T.CustomError>) -> Bool {
        switch (request, error) {
        case (request, _) where request is LoginRequest: return false
        case (request, .notAuthorized) where request.authNeeded: return true
        case (_, .custom(_)): return false
        default: return true
        }
    }
}


#if DEBUG
final fileprivate class SessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
#endif
