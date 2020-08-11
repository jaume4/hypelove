//
//  TrackDetails.swift
//  HypeLove
//
//  Created by Jaume on 10/08/2020.
//

import Foundation
import SwiftUI

struct TrackDetails: Identifiable, Equatable, Hashable {
    let id: String
    let color: Color
    let title: String
    let artist: String
    let duration: String
    let lovedCount: Int
    let lovedDate: Date?
    
    init(_ track: TrackListResponseElement) {
        let colorString = track.thumbURL.lastPathComponent.replacingOccurrences(of: ".png", with: "")
        let color = Color(hex: colorString) ?? .black
        let duration = MinuteSecondsFormatter.format(track.time)

        self.id = track.itemid
        self.color = color
        self.title = track.title
        self.artist = track.artist
        self.duration = duration
        self.lovedCount = track.lovedCount
        self.lovedDate = track.lovedDate
        
        
        
        //                print("""
        //TrackDetails(color: Color(hex: "\(colorString!)")!, title: "\(track.title)", artist: "\(track.artist)", duration: "\(MinuteSecondsFormatter.format(track.time))"),
        //""")
    }
    
    static func == (lhs: TrackDetails, rhs: TrackDetails) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let placeholderTracks: [TrackDetails] = [
        TrackDetails(color: .random, title: "Getting There From Here (with Todd Edwards)", artist: "Poolside", duration: "4:09"),
        TrackDetails(color: .random, title: "BrightonTapes 01", artist: "bonobo", duration: "5:30"),
        TrackDetails(color: .random, title: "Color My Heart (PBR Streetgang Remix)", artist: "Charlotte OC", duration: "10:12"),
        TrackDetails(color: .random, title: "The Heat", artist: "Khamari", duration: "3:18"),
        TrackDetails(color: .random, title: "Vogue (NICOLAAS Remix)", artist: "Madonna", duration: "5:37"),
        TrackDetails(color: .random, title: "Heavy (Icarus Remix)", artist: "Bow Anderson", duration: "30"),
        TrackDetails(color: .random, title: "Way Too Long (Feat Foley)", artist: "Health Club", duration: "3:29"),
        TrackDetails(color: .random, title: "You", artist: "Ross Quinn", duration: "3:48"),
        TrackDetails(color: .random, title: "Maker", artist: "Anjimile", duration: "2:58"),
        TrackDetails(color: .random, title: "Sir Lady Makem Fall", artist: "liv.e", duration: "2:13"),
        TrackDetails(color: .random, title: "Gravity", artist: "Diggs Duke", duration: "2:41"),
        TrackDetails(color: .random, title: "Faith", artist: "I Break Horses", duration: "3:49"),
        TrackDetails(color: .random, title: "Long in the Tooth", artist: "The Budos Band", duration: "3:42"),
        TrackDetails(color: .random, title: "Say The Word feat. Andie Nora", artist: "Moonbootica", duration: "3:26"),
        TrackDetails(color: .random, title: "Sure Shot", artist: "Bathe", duration: "2:49"),
        TrackDetails(color: .random, title: "I Wish I Never Saw The Sunshine", artist: "The Ronettes", duration: "3:49"),
        TrackDetails(color: .random, title: "I Don't Wanna Be Mad at You", artist: "ELINA ERIKSSON", duration: "3:01"),
        TrackDetails(color: .random, title: "Someday (Robin Guthrie Version)", artist: "Fawns of Love x Robin Guthrie", duration: "3:59"),
        TrackDetails(color: .random, title: "Lose Your Love", artist: "Dirty Projectors", duration: "2:49"),
        TrackDetails(color: .random, title: "Fearless", artist: "Jon Hassell", duration: "8:02"),
        TrackDetails(color: .random, title: "Broken Satellite", artist: "Hiro Ama", duration: "4:36"),
        TrackDetails(color: .random, title: "Bossy Woman", artist: "Tiny Powell", duration: "2:58"),
        TrackDetails(color: .random, title: "Little Boots", artist: "Locussolus", duration: "7:47"),
        TrackDetails(color: .random, title: "Dunkirk", artist: "Silverbacks", duration: "3:10"),
        TrackDetails(color: .random, title: "Time (You and I)", artist: "Khruangbin", duration: "5:42"),
        TrackDetails(color: .random, title: "Get Happy", artist: "Blue Hawaii", duration: "4:24"),
        TrackDetails(color: .random, title: "In Two", artist: "Blue Hawaii", duration: "3:25"),
        TrackDetails(color: .random, title: "No One Like You", artist: "Blue Hawaii", duration: "4:31"),
        TrackDetails(color: .random, title: "So We Won’t Forget", artist: "Khruangbin", duration: "4:58"),
        TrackDetails(color: .random, title: "Emergency Equipment and Exits", artist: "Ganser", duration: "5:29"),
        TrackDetails(color: .random, title: "Set Me Free (Song for a Person Walking Away) (Extended)", artist: "LUXXURY", duration: "5:23"),
        TrackDetails(color: .random, title: "Too Late", artist: "Washed Out", duration: "4:12"),
        TrackDetails(color: .random, title: "I'm Hot (Van She Tech Remix!!!)", artist: "Ajax", duration: "5:05"),
        TrackDetails(color: .random, title: "Make The World Go Round", artist: "DJ Cassidy feat. R. Kelly", duration: "4:49"),
        TrackDetails(color: .random, title: "Jou-tau", artist: "Mong Tong 夢東", duration: "4:50"),
        TrackDetails(color: .random, title: "Check To Check", artist: "Open Mike Eagle", duration: "2:04"),
        TrackDetails(color: .random, title: "Kane Train (feat. Freddie Gibbs)", artist: "Machinedrum", duration: "2:17"),
        TrackDetails(color: .random, title: "Hide From The Sun", artist: "GOAT", duration: "3:36"),
        TrackDetails(color: .random, title: "THE DIFFERENCE", artist: "John War", duration: "4:08"),
        TrackDetails(color: .random, title: "It Feels Right", artist: "DOV", duration: "4:33"),
        TrackDetails(color: .random, title: "Charms feat. KeiyaA", artist: "Armand Hammer", duration: "2:37"),
        TrackDetails(color: .random, title: "Gunship", artist: "Locussolus", duration: "8:02"),
        TrackDetails(color: .random, title: "Family Secrets (Intro)", artist: "Conway The Machine", duration: "1:20"),
        TrackDetails(color: .random, title: "Headless Horseman", artist: "The Microphones", duration: "3:10"),
        TrackDetails(color: .random, title: "patience (prod. absent avery)", artist: "lojii", duration: "2:56"),
        TrackDetails(color: .random, title: "Wave Funk", artist: "DMX Krew", duration: "2:14"),
        TrackDetails(color: .random, title: "Dancing Star", artist: "LILIES ON MARS", duration: "4:21"),
    ]
    
    init(color: Color, title: String, artist: String, duration: String) {
        self.id = UUID().uuidString
        self.color = color
        self.title = title
        self.artist = artist
        self.duration = duration
        self.lovedCount = Int.random(in: 0...Int.max)
        self.lovedDate = nil
    }
}
