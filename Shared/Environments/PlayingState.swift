//
//  PlayingState.swift
//  HypeLove
//
//  Created by Jaume on 10/08/2020.
//

import Foundation

final class PlayingState: ObservableObject {
    @Published var currentTrack: TrackDetails?
    @Published var playing = false
    
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
    
    static let noSong: PlayingState = {
        let state = PlayingState()
        state.playing = false
        return state
    }()
    #endif
}
