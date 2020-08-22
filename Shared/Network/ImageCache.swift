//
//  ImageCache.swift
//  HypeLove
//
//  Created by Jaume on 22/08/2020.
//

import Foundation
import Combine
import SwiftUI

final class ImageCache {
    
    private let cache = NSCache<NSURL, UIImage>()
    static let shared = ImageCache()
    private var cancellabes: Set<AnyCancellable> = []
    
    private init() {}
    
    func image(from url: URL) -> AnyPublisher<Image?, Never> {
        
        //Cached image
        if let image = cache.object(forKey: url as NSURL) {
            return Just(Image(uiImage: image)).eraseToAnyPublisher()
        }
        
        //Download and cache
        return Future<Image?, Never> { promise in
            
            let request = DownloadImageRequest(url: url)
            NetworkClient.shared
                .send(request)
                .replaceError(with: nil)
                .sink { image in
                    if let image = image {
                        self.cache.setObject(image, forKey: url as NSURL)
                        promise(.success(Image(uiImage: image)))
                    } else {
                        promise(.success(nil))
                    }
                }
                .store(in: &self.cancellabes)
        }.eraseToAnyPublisher()
    }
}
