//
//  TrackListRequest.swift
//  HypeLove
//
//  Created by Jaume on 08/08/2020.
//

import Foundation

enum TrackListMode: String {
    case all, fresh, noremix, remix
}

struct TrackListRequest: ApiRequest {
    
    typealias Response = [TrackListResponseElement]
    
    let endPoint = "popular"
    let method = HTTPMethod.get
    let urlParams: [String: String]
    let authNeeded = false
    
    init(page: Int, mode: TrackListMode?) {
        var params: [String: String] = ["page": "\(page)"]
        params["mode"] = mode?.rawValue
        urlParams = params
    }
}


struct TrackListResponseElement: Codable {
    let itemid, artist, title: String
    let dateposted: Date
    let siteid: Int
    let sitename: String
    let posturl: String
    let postid, lovedCount, postedCount: Int
    let thumbURL: URL
    let thumbURLMedium: URL?
    let thumbURLLarge: URL
    let time: Int
    let trackListResponseDescription: String
    let itunesLink: String
    let lovedDate: Date?

    enum CodingKeys: String, CodingKey {
        case itemid, artist, title, dateposted, siteid, sitename, posturl, postid
        case lovedCount = "loved_count"
        case postedCount = "posted_count"
        case thumbURL = "thumb_url"
        case thumbURLMedium = "thumb_url_medium"
        case thumbURLLarge = "thumb_url_large"
        case time
        case trackListResponseDescription = "description"
        case itunesLink = "itunes_link"
        case lovedDate = "ts_loved_me"
    }
}
