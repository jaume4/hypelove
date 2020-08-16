//
//  MetadataHandler.swift
//  HypeLove
//
//  Created by Jaume on 15/08/2020.
//

import Foundation
import MediaPlayer

struct StaticMetadata {
    
    let assetURL: URL
    let title: String
    let artist: String
    let artwork: MPMediaItemArtwork?
    
}

struct DynamicMetadata {
    
    let rate: Float
    let position: Float
    let duration: Float
    
}

enum MetadataHandler {
    
    static let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
    
    static func setNowPlayingMetadata(_ metadata: StaticMetadata) {
       
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = [String: Any]()
        
        nowPlayingInfo[MPNowPlayingInfoPropertyAssetURL] = metadata.assetURL
        nowPlayingInfo[MPMediaItemPropertyTitle] = metadata.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = metadata.artist
        nowPlayingInfo[MPMediaItemPropertyArtwork] = metadata.artwork
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    static func setNowPlayingPlaybackInfo(isPlaying: Bool, _ metadata: DynamicMetadata) {
        
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = metadata.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = metadata.position
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = metadata.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = 1.0
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
}
