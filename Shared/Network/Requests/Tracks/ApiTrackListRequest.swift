//
//  ApiTrackListRequest.swift
//  HypeLove
//
//  Created by Jaume on 14/08/2020.
//

import Foundation

protocol ApiTrackListRequest: ApiRequest & NetworkRequest {
    init(endPoint: TracksMode, page: Int)
}

extension ApiTrackListRequest where Self.CustomError == TrackListResponseError {
    
    var controlledErrorCodes: Set<Int> { [404] }
    func processError(code: Int, data: Data) -> NetworkError<TrackListResponseError>? {
        if code == 404 {
            return .custom(.noMoreTracks)
        } else {
            return Self.processError(controlledErrorCodes, code, data)
        }
    }
    
}

extension ApiTrackListRequest {
    
    static func requestMaker(endPoint: TracksMode) -> ((Int) -> Self) {
        return { page in
            Self.init(endPoint: endPoint, page: page)
        }
    }
}

enum TrackListResponseError: String {
    case noMoreTracks = "Couldn't find tracks"
}
