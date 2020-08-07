//
//  NetworkClient.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//  Copyright © 2020 Jaume. All rights reserved.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NoCustomError: String {
    static let noCustomErrorCodes: Set<Int> = []
    case none
}

struct ErrorFormat: Decodable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message = "error_msg"
    }
}

protocol NetworkRequest {
    associatedtype Response: Decodable
    associatedtype CustomError: RawRepresentable = NoCustomError where CustomError.RawValue == String
    var endPoint: String { get }
    var method: HTTPMethod { get }
    var controlledErrorCodes: Set<Int> { get }
}

extension NetworkRequest {
    var controlledErrorCodes: Set<Int> {
        return NoCustomError.noCustomErrorCodes
    }
}

protocol NetworkPostRequest: NetworkRequest {
    associatedtype Body: Encodable
}

protocol NetworkFormRequest: NetworkRequest {
    var params: [String: String] { get }
}

enum NetworkError<CustomError: RawRepresentable>: Error, Equatable where CustomError.RawValue == String {
    
    case noConnection, serverError, notAuthorized, notFound, decoding(DecodingError), unknown, custom(CustomError)
    
    static func processCustomError(error: String) -> NetworkError {
        if let customError = CustomError(rawValue: error) {
            return NetworkError.custom(customError)
        } else {
            return NetworkError.unknown
        }
    }
    
    static func == (lhs: NetworkError<CustomError>, rhs: NetworkError<CustomError>) -> Bool {
        switch (lhs, rhs) {
        case (.noConnection, .noConnection): return true
        case (.serverError, .serverError): return true
        case (.notAuthorized, .notAuthorized): return true
        case (.notFound, .notFound): return true
        case (.unknown, .unknown): return true
        case (.decoding(_), .decoding(_)): return true
        case (.custom(let lhsRawValue), .custom(let rhsRawValue)): return lhsRawValue == rhsRawValue
        default: return false
                    }
    }
    
    static func processResponse<T: NetworkRequest>(data: Data, response: URLResponse, decoder: JSONDecoder, errorCodes: T) throws -> T.Response {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        //Check for custom error codes
        if errorCodes.controlledErrorCodes.contains(httpResponse.statusCode),
           let error = try? NetworkClient.shared.decoder.decode(ErrorFormat.self, from: data) {
            throw processCustomError(error: error.message)
        }
        
        //No custom error, check codes normally and try decode if 2XX
        switch httpResponse.statusCode {
        case 200...299: return try decoder.decode(T.Response.self, from: data)
        case 401: throw NetworkError.notAuthorized
        case 500...599: throw NetworkError.serverError
        default: throw NetworkError.unknown
        }
    }
}

final class NetworkClient {
    
    static let shared = NetworkClient()
    
    private let baseURL = URL(string: "https://api.hypem.com")!
    private let version = "v2"
    
    fileprivate let decoder = JSONDecoder()
    private let encoder = JSONDecoder()
    private let session: URLSession
    
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
                try NetworkError<T.CustomError>.processResponse(data: data, response: response, decoder: self.decoder, errorCodes: request)
            }
            .mapError { error -> NetworkError<T.CustomError> in
                if let error = error as? NetworkError<T.CustomError> {
                    return error
                } else {
                    return NetworkError<T.CustomError>.unknown
                }
            }
            .tryCatch{ (error) throws -> AnyPublisher<T.Response, NetworkError<T.CustomError>> in
                guard !retrying && !(request is LoginRequest) else { throw error }
                retrying = true
                guard error == NetworkError<T.CustomError>.notAuthorized else { throw error }
                return self.resendRequest(request)
            }
            .mapError{ error in
                if let error = error as? NetworkError<T.CustomError> {
                    return error
                } else {
                    return NetworkError<T.CustomError>.unknown
                }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
