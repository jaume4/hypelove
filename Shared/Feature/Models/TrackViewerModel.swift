//
//  TrackViewerModel.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import Foundation
import Combine

final class TrackViewerModel: ObservableObject {
    @Published var tracks: [TrackDetails] = []
    @Published var placholder: Bool = true
    @Published var loading: Bool = false
    @Published var error: NetworkError<TrackListRequest.CustomError>? = nil
    @Published var mode: PopularMode = .now
    
    var store: TracksDownloader
    
    init(store: TracksDownloader, userState: UserState) {
        self.store = store

        store.$tracks.assign(to: &$tracks)
        store.$placeholderTracks.assign(to: &$placholder)
        store.$error.assign(to: &$error)
        store.$tracksCancellable.map{ $0 != nil }.assign(to: &$loading)
        userState.$popularMode.assign(to: &$mode)
    }
    
    func replace(store: TracksDownloader) {
        self.store = store
        
        store.$tracks.assign(to: &$tracks)
        store.$placeholderTracks.assign(to: &$placholder)
        store.$error.assign(to: &$error)
        store.$tracksCancellable.map{ $0 != nil }.assign(to: &$loading)
    }
}
