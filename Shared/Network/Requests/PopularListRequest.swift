//
//  PopularListRequest.swift
//  HypeLove
//
//  Created by Jaume on 08/08/2020.
//

import Foundation

enum PopularMode: String, Hashable {
    case now = ""
    case lastWeek = "lastweek"
    case noRemix = "noRemix"
    case remix
    
    var title: String {
        switch self {
        case .now: return "Popular now"
        case .lastWeek: return "Popular last week"
        case .noRemix: return "No remix"
        case .remix: return "Remix"
        }
    }
}

struct PopularListRequest: ApiRequest {
    
    typealias Response = [TrackListResponseElement]
    
    let endPoint = "popular"
    let method = HTTPMethod.get
    let urlParams: [String: String]
    let authNeeded = false
    
    init(page: Int, mode: PopularMode) {
        var params: [String: String] = ["page": "\(page)"]
        if !mode.rawValue.isEmpty {
            params["mode"] = mode.rawValue
        }
        urlParams = params
    }
}
