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
    
    init(_ track: TrackListResponseElement) {
        let colorString = track.thumbURL.split(separator: "/").last?.replacingOccurrences(of: ".png", with: "")
        let color = colorString.flatMap(Color.init(hex:)) ?? .black
        let duration = MinuteSecondsFormatter.format(track.time)

        self.color = color
        self.title = track.title
        self.artist = track.artist
        self.duration = duration
        
        //                print("""
        //TrackDetails(color: Color(hex: "\(colorString!)")!, title: "\(track.title)", artist: "\(track.artist)", duration: "\(MinuteSecondsFormatter.format(track.time))"),
        //""")
    }
    
    #if DEBUG
    internal init(color: Color, title: String, artist: String, duration: String) {
        self.color = color
        self.title = title
        self.artist = artist
        self.duration = duration
    }
    #endif
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
            print("ended request")
        }, receiveValue: { [weak self] (tracksResponse) in
            guard let self = self else { return }
            self.currentPage += 1
            self.tracks += tracksResponse.map(TrackDetails.init)
        })
    }
}
