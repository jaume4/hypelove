//
//  NetworkError.swift
//  HypeLove
//
//  Created by Jaume on 08/08/2020.
//

import Foundation

enum NetworkError<CustomError: RawRepresentable>: Error, Equatable where CustomError.RawValue == String {
    
    case noConnection, serverError, notAuthorized, notFound, encoding(Error), decoding(Error), unknown, custom(CustomError)
    
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
        case (.encoding(_), .encoding(_)): return true
        case (.custom(let lhsRawValue), .custom(let rhsRawValue)): return lhsRawValue == rhsRawValue
        default: return false
        }
    }
    
    static func convert<FromCustomError: RawRepresentable>(from: NetworkError<FromCustomError>) -> Self {
        switch from {
        case .noConnection: return .noConnection
        case .serverError: return .serverError
        case .notAuthorized: return .notAuthorized
        case .notFound: return .notFound
        case .encoding(let error): return .encoding(error)
        case .decoding(let error): return .decoding(error)
        case .unknown, .custom(_): return .unknown
        }
    }
}

enum NoCustomError: String {
    case none
}

struct ErrorResponse: Decodable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message = "error_msg"
    }
}
