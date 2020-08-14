//
//  FavoritesViewModel.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import Foundation
import Combine

final class FavoritesViewModel: ObservableObject {
    @Published var tracks: [TrackDetails] = []
    @Published var placeholder: Bool = true
    @Published var loading: Bool = false
    @Published var error: NetworkError<TrackListResponseError>? = nil
    
    private var trackStore: TracksDownloader<FavoritesListRequest>
    private var cancellables: Set<AnyCancellable> = []
    
    init(store: TracksDownloader<FavoritesListRequest>) {
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
    
    private func bind() {
        
        trackStore.$tracks.weakAssign(on: \.tracks, object: self, store: &cancellables)
        trackStore.$placeholderTracks.weakAssign(on: \.placeholder, object: self, store: &cancellables)
        trackStore.$error.weakAssign(on: \.error, object: self, store: &cancellables)
        trackStore.$tracksCancellable.map { $0 != nil }.weakAssign(on: \.loading, object: self, store: &cancellables)
    
    }
}
