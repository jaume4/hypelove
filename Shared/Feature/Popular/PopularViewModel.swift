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
    @Published var mode: PopularMode {
        didSet {
            store.popularMode = mode
        }
    }
    
    private let store: TracksDataStore
    private var trackStore: TracksDownloader
    private var cancellables: Set<AnyCancellable> = []
    private var modeCancellable: AnyCancellable?
    
    init(store: TracksDataStore, mode: PopularMode) {
        self.store = store
        self.trackStore = store.store(for: mode)
        self.mode = store.popularMode
        
        modeCancellable = $mode.sink { [weak self] in
            self?.bind(mode: $0)
        }
        
        bind(mode: mode)
    }
    
    func requestTracks() {
        trackStore.requestTracks()
    }
    
    func resetError() {
        trackStore.resetError()
    }
    
    private func bind(mode: PopularMode) {
        
        let trackStore = store.store(for: mode)

        cancellables.removeAll()

        trackStore.$tracks.sink(receiveValue: { [weak self] in
            self?.tracks = $0
        }).store(in: &cancellables)

        trackStore.$placeholderTracks.sink{ [weak self] in
            self?.placeholder = $0
        }.store(in: &cancellables)

        trackStore.$error.sink{ [weak self] in
            self?.error = $0
        }.store(in: &cancellables)

        trackStore.$tracksCancellable.map{ $0 != nil }.sink{ [weak self] in
            self?.loading = $0
        }.store(in: &cancellables)
    }
}
