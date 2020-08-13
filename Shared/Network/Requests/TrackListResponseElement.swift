//
//  TrackListResponseElement.swift
//  HypeLove
//
//  Created by Jaume on 13/08/2020.
//

import Foundation

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
    let time: Int
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
