//
//  DownloadImageRequest.swift
//  HypeLove
//
//  Created by Jaume on 11/08/2020.
//

import Foundation
import SwiftUI

struct DownloadImageRequest: NetworkRequest {
    
    typealias Response = UIImage?
    
    let url: URL
    let method = HTTPMethod.get
    let allowCachedResponse = true
    
    func transformResponse(data: Data, response: HTTPURLResponse) throws -> UIImage? {
        guard let uiImage = UIImage(data: data) else { throw NetworkError<DownloadImageRequest.CustomError>.unknown }
        return uiImage
    }
    
}
