//
//  FavoritesListRequest.swift
//  HypeLove
//
//  Created by Jaume on 13/08/2020.
//

import Foundation

struct FavoritesListRequest: ApiRequest {
    
    typealias Response = [TrackListResponseElement]
    
    let endPoint = "favorites"
    let method = HTTPMethod.get
    let urlParams: [String: String]
    let authNeeded = true
    
    init(page: Int) {
        urlParams = ["page": "\(page)", "count": "100"]
    }
}
