//
//  TrackViewerModel.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import Foundation
import Combine

final class PopularViewModel: ObservableObject {
    @Published var tracks: [TrackDetails] = []
    @Published var placeholder: Bool = true
    @Published var loading: Bool = false
    @Published var error: NetworkError<PopularListRequest.CustomError>? = nil
    @Published var store: TracksDataStore
    
    private var trackStore: TracksDownloader<PopularListRequest>
    private var cancellables: Set<AnyCancellable> = []
    private var modeCancellable: AnyCancellable?
    
    init(store: TracksDataStore, mode: PopularMode, bindModeChange: Bool) {
        self.store = store
        self.trackStore = store.store(for: mode)
        
        if bindModeChange {
            modeCancellable = store.$popularMode.removeDuplicates().sink { [weak self] in
                self?.bind(mode: $0)
            }
        }
        
        bind(mode: mode)
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
    
    private func bind(mode: PopularMode) {
        
        trackStore = store.store(for: mode)

        cancellables.removeAll()
        
        trackStore.$tracks.weakAssign(on: \.tracks, object: self, store: &cancellables)
        trackStore.$placeholderTracks.weakAssign(on: \.placeholder, object: self, store: &cancellables)
        trackStore.$error.weakAssign(on: \.error, object: self, store: &cancellables)
        trackStore.$tracksCancellable.map { $0 != nil }.weakAssign(on: \.loading, object: self, store: &cancellables)
    
    }
}
