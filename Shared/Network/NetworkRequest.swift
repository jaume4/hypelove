//
//  NetworkRequesswift
//  HypeLove
//
//  Created by Jaume on 08/08/2020.
//

import Foundation

protocol NetworkRequest: Equatable {
    associatedtype Response
    associatedtype CustomError: RawRepresentable = NoCustomError where CustomError.RawValue == String
    var endPoint: String { get }
    var authNeeded: Bool { get }
    var urlParams: [String: String] { get }
    var method: HTTPMethod { get }
    var controlledErrorCodes: Set<Int> { get }
    func transformResponse(data: Data, response: HTTPURLResponse) throws -> Response
    func processError(code: Int, data: Data) -> NetworkError<CustomError>
}

extension NetworkRequest {
    var controlledErrorCodes: Set<Int> { [] }
    var urlParams: [String: String] { [:] }
}

extension NetworkRequest where Response: Decodable {
    func transformResponse(data: Data, response: HTTPURLResponse) throws -> Response {
        let response = try NetworkClient.shared.decoder.decode(Response.self, from: data)
        return response
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
        case 401: return .notAuthorized
        case 404: return .notFound
        case 500...599: return .serverError
        default: return .unknown
        }
    }
}

//MARK: - Request types
protocol NetworkEncodableRequest: NetworkRequest {
    associatedtype Body: Encodable
    var body: Body { get }
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
