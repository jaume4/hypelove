//
//  NetworkClient.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//  Copyright © 2020 Jaume. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

typealias RequestPublisher<T: NetworkRequest> = AnyPublisher<T.Response, NetworkError<T.CustomError>>

final class NetworkClient {
    
    static let shared = NetworkClient()
    
    @AppStorage("deviceID") var deviceID: String = ""
    let host = "api.hypem.com"
//    let host = "192.168.1.2"
    let version = "v2"
    let session: URLSession
    private let downloadSession: URLSession
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    private var loginPublisher: RequestPublisher<LoginRequest>?
    private var currentCancellables: Set<AnyCancellable> = []
    private let userAgent = "HypeLove \(AppInfo.appVersion)-\(AppInfo.buildNumber)"
    
    @Published var token: String?
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = .shared
        configuration.requestCachePolicy = .reloadRevalidatingCacheData
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 120
        decoder.dateDecodingStrategy = .secondsSince1970
        encoder.dateEncodingStrategy = .secondsSince1970
        
        let downloadConfiguration = URLSessionConfiguration.default
        downloadConfiguration.urlCache = .shared
        downloadConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        downloadConfiguration.timeoutIntervalForRequest = 30
        downloadConfiguration.timeoutIntervalForResource = 120
        
        #if !DEBUG
        session = URLSession(configuration: configuration)
        downloadSession = URLSession(configuration: downloadConfiguration)
        #else
        session = URLSession(configuration: configuration, delegate: SessionDelegate(), delegateQueue: nil)
        downloadSession = URLSession(configuration: downloadConfiguration, delegate: SessionDelegate(), delegateQueue: nil)
        #endif
    }

    private func makeBaseURLRequest<T: NetworkRequest>(_ request: T) -> URLRequest {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        return urlRequest
    }
    
    //MARK: - Exposed send request methods
    func send<T: NetworkRequest>(_ request: T) -> RequestPublisher<T> {
        let urlRequest = makeBaseURLRequest(request)
        return send(request, urlRequest: urlRequest)
    }
    
    func send<T: NetworkFormRequest>(_ request: T) -> RequestPublisher<T> {
        var urlRequest = makeBaseURLRequest(request)
        urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let formBody = request.params.reduce("", { $0 + $1.key + "=" + $1.value + "&" })
        urlRequest.httpBody = Data(formBody.utf8)
        return send(request, urlRequest: urlRequest)
    }
    
    func send<T: NetworkEncodableRequest>(_ request: T) -> RequestPublisher<T> {
        var urlRequest = makeBaseURLRequest(request)
        do {
            urlRequest.httpBody = try encoder.encode(request.body)
            return send(request, urlRequest: urlRequest)
        } catch {
            return Fail(outputType: T.Response.self, failure: NetworkError<T.CustomError>.encoding(error)).receive(on: DispatchQueue.main).eraseToAnyPublisher()
        }
    }
    
    //MARK: - Request handling and sending
    
    /// Sends any NetworkRequest and retries it if an error is given and [shouldRetry](x-source-tag://ShouldRetry) returns true
    private func send<T: NetworkRequest>(_ request: T, urlRequest: URLRequest) -> RequestPublisher<T> {
        
        if let request = request as? ApiRequest, request.authNeeded, token == nil {
            return Fail(error: NetworkError<T.CustomError>.notAuthorized)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        var retrying = false
        let requestPublisher: URLSession.DataTaskPublisher
        
        if request.allowCachedResponse {
            requestPublisher = downloadSession.dataTaskPublisher(for: urlRequest)
        } else {
            requestPublisher = session.dataTaskPublisher(for: urlRequest)
        }
        
        return requestPublisher
            .receive(on: DispatchQueue.global())
            .subscribe(on: DispatchQueue.global())
            .tryMap { data, response in
                try NetworkClient.process(data, response, for: request)
            }
            .mapError { error -> NetworkError<T.CustomError> in
                (error as? NetworkError<T.CustomError>) ?? NetworkError<T.CustomError>.noConnection
            }
            .tryCatch{ (error) throws -> AnyPublisher<T.Response, NetworkError<T.CustomError>> in
                guard !retrying, self.shouldRetry(request: request, error: error) else { throw error }
                retrying = true
                return self.resendRequest(request)
            }
            .mapError{ error in
                return (error as? NetworkError<T.CustomError>) ?? NetworkError<T.CustomError>.unknown
            }
//            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Retries the given request attemting to login first
    /// - Parameter request: Request to retry
    /// - Returns: Future that fullfills after login attempt is finished and request is resent, or on login error
    private func resendRequest<T: NetworkRequest>(_ request: T) -> RequestPublisher<T> {
        
        let promise = Future<T.Response, NetworkError<T.CustomError>>  { promise in
            
            let loginPublisher: AnyPublisher<LoginRequest.Response, NetworkError<LoginRequest.CustomError>>
            let updateToken: Bool //Only the first suscriber to loginPublisher will update the token to prevent a race condition
            
            if let currentPublisher = self.loginPublisher {
                updateToken = false
                loginPublisher = currentPublisher
            } else {
                updateToken = true
                #warning("fix data")
                let loginRequest = LoginRequest(userName: "", password: "", deviceID: "")
                let urlRequest = self.makeBaseURLRequest(loginRequest)
                loginPublisher = self.send(loginRequest, urlRequest: urlRequest).share().eraseToAnyPublisher()
                self.loginPublisher = loginPublisher
            }

            loginPublisher
                .sink { completion in
                    switch completion {
                    case .finished:
                        //Login finished, resend request regenerating urlRequest as token has changed
                        self.send(request, urlRequest: self.makeBaseURLRequest(request))
                            .sink { completion in
                                switch completion {
                                case .finished: return
                                case .failure(let error): promise(.failure(error))
                                }
                            } receiveValue: { response in
                                promise(.success(response))
                            }.store(in: &self.currentCancellables)
                    case .failure(let error):
                        //Custom error are wrong user name or password, convert to not authorized, else convert normally
                        if case .custom(_) = error {
                            promise(.failure(NetworkError<T.CustomError>.notAuthorized))
                        } else {
                            let convertedError = NetworkError<T.CustomError>.convert(from: error)
                            promise(.failure(convertedError))
                        }
                    }
                } receiveValue: { (response) in
                    //Succeeded refresh
                    if updateToken {
                        self.token = response.hmToken
                    }
                }.store(in: &self.currentCancellables)
        }
        
        return promise.eraseToAnyPublisher()
    }
    
    //MARK: - Request and error processing
    
    /// Tries to transform data from response to request Response, throws if fails or status code is not 2XX
    static func process<T: NetworkRequest>(_ data: Data, _ response: URLResponse, for request: T) throws -> T.Response {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError<T.CustomError>.unknown
        }
        
        let statusCode = response.statusCode
        
        guard 200...299 ~= statusCode else {
            if request.controlledErrorCodes.contains(response.statusCode), let error = request.processError(code: statusCode, data: data) {
                throw error
            } else {
                throw processError(code: statusCode, request: request)
            }
        }
        
        return try request.transformResponse(data: data, response: response)
    }
    
    //Process standard errors
    static func processError<T: NetworkRequest>(code: Int, request _: T) -> NetworkError<T.CustomError> {
        switch code {
        case 401: return .notAuthorized
        case 404: return .notFound
        case 500...599: return .serverError
        default: return .unknown
        }
    }
    
    /// Logic for retrying api requests. Login request or custom errors are not retried, not authorized and everything else gets retried.
    /// - Tag: ShouldRetry
    private func shouldRetry<T: NetworkRequest>(request: T, error: NetworkError<T.CustomError>) -> Bool {
        guard let request = request as? ApiRequest else { return false }
        switch error {
        case _ where request is LoginRequest: return false
        case .notAuthorized: return request.authNeeded
        default: return false
        }
    }
}


#if DEBUG
//Trust mocking server
final fileprivate class SessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.host == "192.168.1.2" {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
#endif
