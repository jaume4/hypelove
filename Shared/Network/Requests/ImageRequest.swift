//
//  ImageRequest.swift
//  HypeLove
//
//  Created by Jaume on 11/08/2020.
//

import Foundation
import SwiftUI

struct ImageRequest: NetworkRequest {
    
    typealias Response = Image
    
    let url: URL
    let method = HTTPMethod.get
    
    func transformResponse(data: Data, response: HTTPURLResponse) throws -> Image {
        guard let uiImage = UIImage(data: data) else { throw NetworkError<ImageRequest.CustomError>.unknown }
        return Image(uiImage: uiImage)
    }
    
}
