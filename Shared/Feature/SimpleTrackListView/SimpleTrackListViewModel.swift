//
//  SimpleTrackListViewModel.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import Foundation
import Combine

final class SimpleTrackListViewModel: ObservableObject {
    @Published var tracks: [TrackDetails] = []
    @Published var placeholder: Bool = true
    @Published var loading: Bool = false
    @Published var error: NetworkError<TrackListRequest.CustomError>? = nil
    
    private var trackStore: TracksDownloader<TrackListRequest>
    private var cancellables: Set<AnyCancellable> = []
    
    init(store: TracksDownloader<TrackListRequest>) {
        self.trackStore = store
        bind()
    }
    
    func requestTracksIfEmpty() {
        trackStore.requestTracksIfEmpty()
    }
    
    func requestTracks() {
        trackStore.requestTracks()
    }
    
    func resetError() {
        trackStore.resetError()
    }
    
    func resetTracks() {
        trackStore.resetTracks()
    }
    
    private func bind() {
        
        trackStore.$tracks.weakAssign(on: \.tracks, object: self, store: &cancellables)
        trackStore.$placeholderTracks.weakAssign(on: \.placeholder, object: self, store: &cancellables)
        trackStore.$error.weakAssign(on: \.error, object: self, store: &cancellables)
        trackStore.$tracksCancellable.map { $0 != nil }.weakAssign(on: \.loading, object: self, store: &cancellables)
    
    }
}
