//
//  TrackViewerModel.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import Foundation
import Combine

final class PopularViewModel: ObservableObject {
    
    @Published private(set) var trackStore: TracksDownloader<TrackListRequest>
    @Published var store: TracksDataStore
    private var modeCancellable: AnyCancellable?
    
    init(store: TracksDataStore, mode: PopularMode, bindModeChange: Bool) {
        self.store = store
        self.trackStore = store.store(for: mode)
        
        modeCancellable = store.$popularMode.removeDuplicates().sink { [unowned self] mode in
            print("change mode to \(mode)")
            self.trackStore = self.store.store(for: mode)
            self.trackStore.requestTracksIfEmpty()
        }
    }
}
