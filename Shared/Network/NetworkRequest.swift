//
//  NetworkRequesswift
//  HypeLove
//
//  Created by Jaume on 08/08/2020.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

//MARK: - Request types

//Base request
protocol NetworkRequest {
    associatedtype Response
    associatedtype CustomError: RawRepresentable = NoCustomError where CustomError.RawValue == String
    var urlParams: [String: String] { get }
    var method: HTTPMethod { get }
    var controlledErrorCodes: Set<Int> { get }
    func transformResponse(data: Data, response: HTTPURLResponse) throws -> Response
    func processError(code: Int, data: Data) -> NetworkError<CustomError>?
    var url: URL { get }
    var allowCachedResponse: Bool { get }
}

protocol ApiRequest {
    var endPoint: String { get }
    var authNeeded: Bool { get }
}

protocol NetworkEncodableRequest: ApiRequest {
    associatedtype Body: Encodable
    var body: Body { get }
}

protocol NetworkFormRequest: ApiRequest {
    var params: [String: String] { get }
}

//MARK: - NetworkRequest extensions

extension NetworkRequest {
    var allowCachedResponse: Bool { false }
    var controlledErrorCodes: Set<Int> { [] }
    var urlParams: [String: String] { [:] }
    
    func processError(code: Int, data: Data) -> NetworkError<CustomError>? {
        Self.processError(controlledErrorCodes, code, data)
    }
}

extension NetworkRequest {
    
    static func processError(_ controlledErrorCodes: Set<Int>, _ code: Int, _ data: Data) -> NetworkError<CustomError>? {
        
        //Check for custom error codes
        if controlledErrorCodes.contains(code),
           let error = try? NetworkClient.shared.decoder.decode(ErrorResponse.self, from: data) {
            return NetworkError<CustomError>.processCustomError(error: error.message)
        } else {
            return nil
        }
    }
}

//MARK: - Network request decodable extension

extension NetworkRequest where Response: Decodable {
    func transformResponse(data: Data, response: HTTPURLResponse) throws -> Response {
        return try NetworkClient.shared.decoder.decode(Response.self, from: data)
    }
}

//MARK: - Api request url generator

extension ApiRequest where Self: NetworkRequest {
    var url: URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = NetworkClient.shared.host
        components.path = "/" + NetworkClient.shared.version + "/" + endPoint
        components.queryItems = urlParams.map(URLQueryItem.init)
        if authNeeded {
            components.queryItems?.append(URLQueryItem(name: "hm_token", value: NetworkClient.shared.token))
            components.queryItems?.append(URLQueryItem(name: "key", value: NetworkClient.shared.deviceID))
        }
        return components.url!
        
    }
}
