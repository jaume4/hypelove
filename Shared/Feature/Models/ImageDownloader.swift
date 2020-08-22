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
    var url: URL?
    
    init(_ url: URL, placeholder: Bool) {
        self.url = url
        if !placeholder {
            download()
        }
    }
    
    init() {}
    
    func download() {
        
        guard let url = url else { return }
        
        ImageCache.shared
            .image(from: url)
            .assign(to: &$image)
    }
    
    func download(url: URL) {
        
        image = nil
        self.url = url
        download()
        
    }
    
    
}
