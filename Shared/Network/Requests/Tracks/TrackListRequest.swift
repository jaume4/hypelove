//
//  TrackListRequest.swift
//  HypeLove
//
//  Created by Jaume on 14/08/2020.
//

import Foundation

struct TrackListRequest: ApiTrackListRequest {
    
    typealias Response = [TrackListResponseElement]
    typealias CustomError = TrackListResponseError
    
    let endPointType: TracksMode
    let method = HTTPMethod.get
    var endPoint: String {
        endPointType.endPoint
    }
    let urlParams: [String : String]
    var authNeeded: Bool {
        return endPointType.authNeeded
    }
    
    init(endPoint: TracksMode, page: Int) {
        self.endPointType = endPoint
        var params = ["page": "\(page)"]
        
        switch endPoint {
        case .popular(let mode):
            if !mode.rawValue.isEmpty {
                params["mode"] = mode.rawValue
            }
        case .new(let mode):
            params["mode"] = mode.rawValue
        default: break
        }
        
        urlParams = params
    }
}

struct TrackListResponseElement: Decodable {
    let itemid, artist, title: String
    let dateposted: Date
    let siteid: Int
    let sitename: String
    let posturl: String
    let postid, lovedCount, postedCount: Int
    let thumbURL: URL
    let thumbURLMedium: URL?
    let thumbURLLarge: URL
    let time: Double
    let description: String
    let itunesLink: String
    let lovedDate: Date?

    enum CodingKeys: String, CodingKey {
        case itemid, artist, title, dateposted, siteid, sitename, posturl, postid
        case lovedCount = "loved_count"
        case postedCount = "posted_count"
        case thumbURL = "thumb_url"
        case thumbURLMedium = "thumb_url_medium"
        case thumbURLLarge = "thumb_url_large"
        case time, description
        case itunesLink = "itunes_link"
        case lovedDate = "ts_loved_me"
    }
}
