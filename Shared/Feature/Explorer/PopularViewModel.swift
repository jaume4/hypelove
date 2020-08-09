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
    
    static let placeholderTracks = [
        TrackDetails(color: Color(hex: "FE0034")!, title: "Getting There From Here (with Todd Edwards)", artist: "Poolside", duration: "4:09"),
        TrackDetails(color: Color(hex: "CA3829")!, title: "BrightonTapes 01", artist: "bonobo", duration: "5:30"),
        TrackDetails(color: Color(hex: "D99884")!, title: "Color My Heart (PBR Streetgang Remix)", artist: "Charlotte OC", duration: "10:12"),
        TrackDetails(color: Color(hex: "2A2014")!, title: "The Heat", artist: "Khamari", duration: "3:18"),
        TrackDetails(color: Color(hex: "4D4C4A")!, title: "Vogue (NICOLAAS Remix)", artist: "Madonna", duration: "5:37"),
        TrackDetails(color: Color(hex: "F1B95C")!, title: "Heavy (Icarus Remix)", artist: "Bow Anderson", duration: "30"),
        TrackDetails(color: Color(hex: "0000D2")!, title: "Way Too Long (Feat Foley)", artist: "Health Club", duration: "3:29"),
        TrackDetails(color: Color(hex: "264A64")!, title: "You", artist: "Ross Quinn", duration: "3:48"),
        TrackDetails(color: Color(hex: "00B6C4")!, title: "Maker", artist: "Anjimile", duration: "2:58"),
        TrackDetails(color: Color(hex: "006CFF")!, title: "Sir Lady Makem Fall", artist: "liv.e", duration: "2:13"),
        TrackDetails(color: Color(hex: "DEA95D")!, title: "Gravity", artist: "Diggs Duke", duration: "2:41"),
        TrackDetails(color: Color(hex: "020200")!, title: "Faith", artist: "I Break Horses", duration: "3:49"),
        TrackDetails(color: Color(hex: "0E0000")!, title: "Long in the Tooth", artist: "The Budos Band", duration: "3:42"),
        TrackDetails(color: Color(hex: "FD185D")!, title: "Say The Word feat. Andie Nora", artist: "Moonbootica", duration: "3:26"),
        TrackDetails(color: Color(hex: "1D2122")!, title: "Sure Shot", artist: "Bathe", duration: "2:49"),
        TrackDetails(color: Color(hex: "813154")!, title: "I Wish I Never Saw The Sunshine", artist: "The Ronettes", duration: "3:49"),
        TrackDetails(color: Color(hex: "84614E")!, title: "I Don't Wanna Be Mad at You", artist: "ELINA ERIKSSON", duration: "3:01"),
        TrackDetails(color: Color(hex: "6B416F")!, title: "Someday (Robin Guthrie Version)", artist: "Fawns of Love x Robin Guthrie", duration: "3:59"),
        TrackDetails(color: Color(hex: "73AAC8")!, title: "Lose Your Love", artist: "Dirty Projectors", duration: "2:49"),
        TrackDetails(color: Color(hex: "F78D1F")!, title: "Fearless", artist: "Jon Hassell", duration: "8:02"),
        TrackDetails(color: Color(hex: "2E3F6B")!, title: "Broken Satellite", artist: "Hiro Ama", duration: "4:36"),
        TrackDetails(color: Color(hex: "83C441")!, title: "Bossy Woman", artist: "Tiny Powell", duration: "2:58"),
        TrackDetails(color: Color(hex: "473E39")!, title: "Little Boots", artist: "Locussolus", duration: "7:47"),
        TrackDetails(color: Color(hex: "DF8584")!, title: "Dunkirk", artist: "Silverbacks", duration: "3:10"),
        TrackDetails(color: Color(hex: "E9C86B")!, title: "Time (You and I)", artist: "Khruangbin", duration: "5:42"),
        TrackDetails(color: Color(hex: "515151")!, title: "Get Happy", artist: "Blue Hawaii", duration: "4:24"),
        TrackDetails(color: Color(hex: "1E3837")!, title: "In Two", artist: "Blue Hawaii", duration: "3:25"),
        TrackDetails(color: Color(hex: "FE9894")!, title: "No One Like You", artist: "Blue Hawaii", duration: "4:31"),
        TrackDetails(color: Color(hex: "E9C86B")!, title: "So We Won’t Forget", artist: "Khruangbin", duration: "4:58"),
        TrackDetails(color: Color(hex: "FCC10F")!, title: "Emergency Equipment and Exits", artist: "Ganser", duration: "5:29"),
        TrackDetails(color: Color(hex: "FE0000")!, title: "Set Me Free (Song for a Person Walking Away) (Extended)", artist: "LUXXURY", duration: "5:23"),
        TrackDetails(color: Color(hex: "1D2943")!, title: "Too Late", artist: "Washed Out", duration: "4:12"),
        TrackDetails(color: Color(hex: "FE1252")!, title: "I'm Hot (Van She Tech Remix!!!)", artist: "Ajax", duration: "5:05"),
        TrackDetails(color: Color(hex: "037339")!, title: "Make The World Go Round", artist: "DJ Cassidy feat. R. Kelly", duration: "4:49"),
        TrackDetails(color: Color(hex: "23336F")!, title: "Jou-tau", artist: "Mong Tong 夢東", duration: "4:50"),
        TrackDetails(color: Color(hex: "57B8C9")!, title: "Check To Check", artist: "Open Mike Eagle", duration: "2:04"),
        TrackDetails(color: Color(hex: "12172B")!, title: "Kane Train (feat. Freddie Gibbs)", artist: "Machinedrum", duration: "2:17"),
        TrackDetails(color: Color(hex: "89C53F")!, title: "Hide From The Sun", artist: "GOAT", duration: "3:36"),
        TrackDetails(color: Color(hex: "F5FE41")!, title: "THE DIFFERENCE", artist: "John War", duration: "4:08"),
        TrackDetails(color: Color(hex: "F15757")!, title: "It Feels Right", artist: "DOV", duration: "4:33"),
        TrackDetails(color: Color(hex: "355DB5")!, title: "Charms feat. KeiyaA", artist: "Armand Hammer", duration: "2:37"),
        TrackDetails(color: Color(hex: "473E39")!, title: "Gunship", artist: "Locussolus", duration: "8:02"),
        TrackDetails(color: Color(hex: "000000")!, title: "Family Secrets (Intro)", artist: "Conway The Machine", duration: "1:20"),
        TrackDetails(color: Color(hex: "002538")!, title: "Headless Horseman", artist: "The Microphones", duration: "3:10"),
        TrackDetails(color: Color(hex: "F6F3EA")!, title: "patience (prod. absent avery)", artist: "lojii", duration: "2:56"),
        TrackDetails(color: Color(hex: "EA3256")!, title: "Wave Funk", artist: "DMX Krew", duration: "2:14"),
        TrackDetails(color: Color(hex: "EF1E1A")!, title: "Dancing Star", artist: "LILIES ON MARS", duration: "4:21"),
    ]
    
    init(color: Color, title: String, artist: String, duration: String) {
        self.color = color
        self.title = title
        self.artist = artist
        self.duration = duration
    }
}

final class PopularViewModel: ObservableObject {
    
    @Published var tracksCancellable: AnyCancellable?
    @Published var mode: TrackListMode?
    @Published var tracks: [TrackDetails] = TrackDetails.placeholderTracks
    @Published var currentlyPlaying: Int?
    private var currentPage = 0
    
    func requestTracks() {
        let request = TrackListRequest(page: currentPage + 1, mode: mode)
        tracksCancellable = NetworkClient.shared.send(request).sink(receiveCompletion: { completion in
            print("ended request")
        }, receiveValue: { [weak self] (tracksResponse) in
            guard let self = self else { return }
            if self.currentPage == 0 {
                self.tracks.removeAll(keepingCapacity: true)
            }
            self.currentPage += 1
            self.tracks += tracksResponse.map(TrackDetails.init)
        })
    }
}
