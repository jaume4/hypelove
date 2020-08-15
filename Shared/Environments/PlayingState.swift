//
//  PlayingState.swift
//  HypeLove
//
//  Created by Jaume on 10/08/2020.
//

import Foundation
import Combine
import AVFoundation
import MediaPlayer

enum PlayState {
    case play
    case pause
    case loading
    case error
}

final class PlayingState: ObservableObject {
    @Published var trackDownload: AnyCancellable?
    @Published var playing = false
    @Published var state = PlayState.pause
    @Published var error: NetworkError<DownloadTrackRequest.CustomError>?
    @Published private(set) var currentTrack: TrackDetails?
    private lazy var player = Player()
    
    func pause() {
        playing = false
    }
    
    func play(track: TrackDetails?) {
        if let track = track, currentTrack != track {
            currentTrack = track
            playing = true
            player.play(tracks: [track])
//            dowloadTrack(track)
        }
    }
    
    func play(tracks: [TrackDetails]) {
      
            playing = true
            player.play(tracks: tracks)
//            dowloadTrack(track)
        
    }
    
    func resume() {
        playing = true
    }
    
    func next() {
        print("next")
    }
    
    #if DEBUG
    static let songPlaying: PlayingState = {
        let state = PlayingState()
        state.playing = true
        state.currentTrack = TrackDetails.placeholderTracks[1]
        return state
    }()
    
    static let songPaused: PlayingState = {
        let state = PlayingState()
        state.playing = false
        state.currentTrack = TrackDetails.placeholderTracks[1]
        return state
    }()
    
    static let songLoading: PlayingState = {
        let state = PlayingState()
        state.playing = false
        state.currentTrack = TrackDetails.placeholderTracks[1]
        return state
    }()
    
    static let noSong: PlayingState = {
        let state = PlayingState()
        state.playing = false
        return state
    }()
    #endif
}
