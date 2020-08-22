//
//  ImageDownloader.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import Foundation
import SwiftUI
import Combine

final class ImageDownloader: ObservableObject {

    @Published var image: Image?
    let url: URL
    
    init(_ url: URL, placeholder: Bool) {
        self.url = url
        if !placeholder {
            download()
        }
    }
    
    func download() {
        
        ImageCache.shared
            .image(from: url)
            .assign(to: &$image)
    }
}
