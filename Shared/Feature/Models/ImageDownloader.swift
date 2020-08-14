//
//  ImageDownloader.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import Foundation
import SwiftUI

final class ImageDownloader: ObservableObject {

    @Published var image: Image?
    
    func download(_ url: URL) {
        let request = DownloadImageRequest(url: url)
        NetworkClient.shared.send(request)
            .replaceError(with: nil)
            .assign(to: &$image)
    }
}
