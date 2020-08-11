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
    @Published var error: NetworkError<TrackListRequest.CustomError>?
    let placeholderTracks = TrackDetails.placeholderTracks
    private var currentPage = 0
    
    func requestTracks() {
        guard tracksCancellable == nil && error == nil else { return }
        let request = TrackListRequest(page: currentPage + 1, mode: mode)
        
        tracksCancellable = NetworkClient.shared.send(request).sink(receiveCompletion: { [weak self] completion in
            
            defer { self?.tracksCancellable = nil }
            
            switch completion {
            case .finished: return
            case .failure(let error): self?.error = error
            }
            
        }, receiveValue: { [weak self] (tracksResponse) in
            guard let self = self else { return }
            self.currentPage += 1
            self.tracks += tracksResponse.map(TrackDetails.init)
        })
    }
    
    func resetError() {
        error = nil
    }
    
    #if DEBUG
    static let tracksLoaded: PopularViewModel = {
        let viewModel = PopularViewModel()
        viewModel.tracks = TrackDetails.placeholderTracks
        return viewModel
    }()
    #endif
}
