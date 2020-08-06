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

protocol CustomControlledErrorCodes {
    var controlledErrorCodes: Set<Int> { get }
}

protocol NetworkRequest: CustomControlledErrorCodes {
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

enum NetworkError<CustomError: RawRepresentable>: Error where CustomError.RawValue == String {
    case noConnection, serverError, noAuthorized, notFound, decoding(Error), unknown, custom(CustomError)
    
    static func processCustomError(error: String) -> NetworkError {
        if let customError = CustomError(rawValue: error) {
            return NetworkError.custom(customError)
        } else {
            return NetworkError.unknown
        }
    }
    
    static func processResponse<T: CustomControlledErrorCodes>(data: Data, response: URLResponse, errorCodes: T) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        //Check for custom error codes
        if errorCodes.controlledErrorCodes.contains(httpResponse.statusCode),
           let error = try? NetworkClient.shared.decoder.decode(ErrorFormat.self, from: data) {
            throw processCustomError(error: error.message)
        }
        
        //No custom error, check codes normally
        switch httpResponse.statusCode {
        case 200...299: return data
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
    
    private func sendRequest<T: NetworkRequest>(_ request: T, urlRequest: URLRequest) -> AnyPublisher<T.Response, NetworkError<T.CustomError>> {
        return session.dataTaskPublisher(for: urlRequest)
        .receive(on: DispatchQueue.global())
        .subscribe(on: DispatchQueue.global())
        .tryMap { data, response in
            try NetworkError<T.CustomError>.processResponse(data: data, response: response, errorCodes: request)
        }
        .decode(type: T.Response.self, decoder: decoder)
        .mapError{ error in
            if let error = error as? NetworkError<T.CustomError> {
                return error
            } else {
                return NetworkError<T.CustomError>.decoding(error)
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
