//
//  FavoritesListRequest.swift
//  HypeLove
//
//  Created by Jaume on 13/08/2020.
//

import Foundation

struct FavoritesListRequest: TrackListRequest {
    
    typealias Response = [TrackListResponseElement]
    typealias CustomError = TrackListResponseError
    
    let endPoint = "me/favorites"
    let method = HTTPMethod.get
    let urlParams: [String: String]
    let authNeeded = true
    
    init(page: Int) {
        urlParams = ["page": "\(page)"]
    }
}
