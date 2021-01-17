//
//  DownloadTrackRequest.swift
//  HypeLove
//
//  Created by Jaume on 14/08/2020.
//

import Foundation
import SwiftUI
import AVFoundation

struct DownloadTrackRequest: NetworkRequest {
    
    typealias Response = AVAudioPlayer
    
    let url: URL
    let method = HTTPMethod.get
    let allowCachedResponse = true
    
    init(track: TrackDetails) {
        self.url = track.url
    }
    
    func transformResponse(data: Data, response: HTTPURLResponse) throws -> AVAudioPlayer {
        return try AVAudioPlayer(data: data)
    }
    
}
