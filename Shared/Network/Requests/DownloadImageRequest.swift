//
//  DownloadImageRequest.swift
//  HypeLove
//
//  Created by Jaume on 11/08/2020.
//

import Foundation
import SwiftUI

struct DownloadImageRequest: NetworkRequest {
    
    typealias Response = Image?
    
    let url: URL
    let method = HTTPMethod.get
    let allowCachedResponse = true
    
    func transformResponse(data: Data, response: HTTPURLResponse) throws -> Image? {
        guard let uiImage = UIImage(data: data) else { throw NetworkError<DownloadImageRequest.CustomError>.unknown }
        return Image(uiImage: uiImage)
    }
    
}
