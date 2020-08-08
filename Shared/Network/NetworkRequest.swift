//
//  NetworkRequesswift
//  HypeLove
//
//  Created by Jaume on 08/08/2020.
//

import Foundation

protocol NetworkRequest {
    associatedtype Response
    associatedtype CustomError: RawRepresentable = NoCustomError where CustomError.RawValue == String
    var endPoint: String { get }
    var method: HTTPMethod { get }
    var controlledErrorCodes: Set<Int> { get }
    func transformResponse(data: Data, response: URLResponse) throws -> Response
    func processError(code: Int, data: Data) -> NetworkError<CustomError>
}

extension NetworkRequest {
    var controlledErrorCodes: Set<Int> {
        return []
    }
}

extension NetworkRequest where Response: Decodable {
    func transformResponse(data: Data, response: URLResponse) throws -> Response {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError<CustomError>.unknown
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw processError(code: httpResponse.statusCode, data: data)
        }
        
        return try NetworkClient.shared.decoder.decode(Response.self, from: data)
    }
}

extension NetworkRequest {
    func processError(code: Int, data: Data) -> NetworkError<CustomError> {
        
        //Check for custom error codes
        if controlledErrorCodes.contains(code),
           let error = try? NetworkClient.shared.decoder.decode(ErrorResponse.self, from: data) {
            return NetworkError<CustomError>.processCustomError(error: error.message)
        }
        
        //No custom error, use stantard errors
        switch code {
        case 401: return NetworkError<CustomError>.notAuthorized
        case 500...599: return NetworkError<CustomError>.serverError
        default: return NetworkError<CustomError>.unknown
        }
    }
}

protocol NetworkEncodableRequest: NetworkRequest {
    associatedtype Body: Encodable
}

protocol NetworkFormRequest: NetworkRequest {
    var params: [String: String] { get }
}


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
