//
//  PopularViewModel.swift
//  HypeLove
//
//  Created by Jaume on 08/08/2020.
//

import Foundation
import Combine
import SwiftUI

struct TrackDetails: Identifiable {
    let id = UUID()
    let color: Color
    let title: String
    let artist: String
    let duration: String
}

final class PopularViewModel: ObservableObject {
    
    @Published var tracksCancellable: AnyCancellable?
    @Published var mode: TrackListMode?
    @Published var tracks: [TrackDetails] = []
    @Published var currentlyPlaying: Int?
    private var currentPage = 0
    
    func requestTracks() {
        let request = TrackListRequest(page: currentPage + 1, mode: mode)
        tracksCancellable = NetworkClient.shared.send(request).sink(receiveCompletion: { completion in
            print(completion)
        }, receiveValue: { [weak self] (tracksResponse) in
            guard let self = self else { return }
            self.currentPage += 1
            self.tracks = tracksResponse.map { track in
                let colorString = track.thumbURL.split(separator: "/").last?.replacingOccurrences(of: ".png", with: "")
                let color = colorString.flatMap(Color.init(hex:)) ?? .black
//                print("""
//TrackDetails(color: Color(hex: "\(colorString!)")!, title: "\(track.title)", artist: "\(track.artist)", duration: "\(MinuteSecondsFormatter.format(track.time))"),
//""")
                return TrackDetails(color: color, title: track.title, artist: track.artist, duration: MinuteSecondsFormatter.format(track.time))
            }
        })
    }
}
