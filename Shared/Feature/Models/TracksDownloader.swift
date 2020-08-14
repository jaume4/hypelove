//
//  TracksDownloader.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import Foundation
import Combine

final class TracksDownloader<Request: ApiTrackListRequest>: ObservableObject where Request.Response == [TrackListResponseElement] {
    
    @Published private(set) var tracks: [TrackDetails] = Array(TrackDetails.placeholderTracks.prefix(10))
    @Published private(set) var error: NetworkError<Request.CustomError>?
    @Published private(set) var tracksCancellable: AnyCancellable?
    @Published private(set) var placeholderTracks = true
    
    private var currentPage = 0
    let makeRequest: (Int) -> Request
    
    init(endPoint: TracksEndPoint) {
        makeRequest = Request.requestMaker(endPoint: endPoint)
    }
    
    func requestTracksIfEmpty() {
        guard placeholderTracks else { return }
        requestTracks()
    }
    
    func requestTracks() {
        guard tracksCancellable == nil && error == nil else { return }
        let request = makeRequest(currentPage + 1)
        
        tracksCancellable = NetworkClient.shared.send(request).sink(receiveCompletion: { completion in
            
            defer { self.tracksCancellable = nil }
            
            switch completion {
            case .finished: return
            case .failure(let error): self.error = error
            }
            
        }, receiveValue: { (tracksResponse) in
            self.currentPage += 1
            if self.placeholderTracks {
                self.placeholderTracks = false
                self.tracks.removeAll(keepingCapacity: true)
            }
            self.tracks += tracksResponse.map(TrackDetails.init)
        })
    }
    
    func resetError() {
        error = nil
    }
}
