//
//  PopularViewModel.swift
//  HypeLove
//
//  Created by Jaume on 08/08/2020.
//

import Foundation
import Combine

struct TrackElement {
    let title: String
}

final class PopularViewModel: ObservableObject {
    
    @Published var tracksCancellable: AnyCancellable?
    @Published var mode: TrackListMode?
    var currentPage = 0
    
    func requestTracks() {
        let request = TrackListRequest(page: currentPage + 1, mode: mode)
        tracksCancellable = NetworkClient.shared.send(request).sink(receiveCompletion: { completion in
            print("Ended popular tracks")
            print(completion)
        }, receiveValue: { [weak self] (tracks) in
            self?.currentPage += 1
            print(tracks)
        })
    }
}
