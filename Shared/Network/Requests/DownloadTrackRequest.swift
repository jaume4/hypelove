//
//  DownloadTrackRequest.swift
//  HypeLove
//
//  Created by Jaume on 14/08/2020.
//

import Foundation
import SwiftUI

struct DownloadTrackRequest: NetworkRequest {
    
    typealias Response = Data
    
    let url: URL
    let method = HTTPMethod.get
    let allowCachedResponse = true
    
    func transformResponse(data: Data, response: HTTPURLResponse) throws -> Data {
        return data
    }
    
}
