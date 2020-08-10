//
//  PopularViewModel.swift
//  HypeLove
//
//  Created by Jaume on 08/08/2020.
//

import Foundation
import Combine
import SwiftUI

final class PopularViewModel: ObservableObject {
    
    @Published var tracksCancellable: AnyCancellable?
    @Published var mode: TrackListMode?
    @Published var tracks: [TrackDetails] = []
    @Published var currentlyPlaying: Int?
    let placeholderTracks = TrackDetails.placeholderTracks
    private var currentPage = 0
    
    func requestTracks() {
        guard tracksCancellable == nil else { return }
        let request = TrackListRequest(page: currentPage + 1, mode: mode)
        tracksCancellable = NetworkClient.shared.send(request).sink(receiveCompletion: { [weak self] completion in
            self?.tracksCancellable = nil
            #warning("control error")
            print("ended request")
        }, receiveValue: { [weak self] (tracksResponse) in
            guard let self = self else { return }
            self.currentPage += 1
            self.tracks += tracksResponse.map(TrackDetails.init)
        })
    }
    
    #if DEBUG
    static let tracksLoaded: PopularViewModel = {
        let viewModel = PopularViewModel()
        viewModel.tracks = TrackDetails.placeholderTracks
        return viewModel
    }()
    #endif
}
