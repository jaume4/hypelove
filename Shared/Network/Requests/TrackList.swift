//
//  TrackList.swift
//  HypeLove
//
//  Created by Jaume on 14/08/2020.
//

import Foundation

protocol TrackListRequest: ApiRequest {}

extension TrackListRequest where Self.CustomError == TrackListResponseError {
    
    var controlledErrorCodes: Set<Int> { [404] }
    func processError(code: Int, data: Data) -> NetworkError<TrackListResponseError>? {
        if code == 404 {
            return .custom(.noMoreTracks)
        } else {
            return Self.processError(controlledErrorCodes, code, data)
        }
    }
}

enum TrackListResponseError: String {
    case noMoreTracks = "No more tracks found"
}
