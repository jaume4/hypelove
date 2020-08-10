//
//  PlayingState.swift
//  HypeLove
//
//  Created by Jaume on 10/08/2020.
//

import Foundation

enum PlayState {
    case play
    case pause
    case loading
}

final class PlayingState: ObservableObject {
    @Published var currentTrack: TrackDetails?
    @Published var playing = false
    
    func pause() {
        playing = false
    }
    
    func play(track: TrackDetails) {
        if currentTrack != track {
            currentTrack = track
            playing = true
        }
    }
    
    func resume() {
        playing = true
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
