//
//  PopularView.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//  Copyright © 2020 Jaume. All rights reserved.
//

import SwiftUI

struct PopularView: View {
    @EnvironmentObject var userState: UserState
    @StateObject var viewModel = PopularViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.tracks) { track in
                    TrackView(track: track)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.requestTracks()
        }
    }
}

struct PopularView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PopularView(viewModel: viewModel)
        }
        .environmentObject(UserState())
    }
    
    static let viewModel: PopularViewModel = {
        let viewModel = PopularViewModel()
        viewModel.tracks = tracks
        return viewModel
    }()
    
    static let tracks = [
        TrackDetails(color: Color(hex: "FE0034")!, title: "Getting There From Here (with Todd Edwards)", artist: "Poolside"),
        TrackDetails(color: Color(hex: "CA3829")!, title: "BrightonTapes 01", artist: "bonobo"),
        TrackDetails(color: Color(hex: "D99884")!, title: "Color My Heart (PBR Streetgang Remix)", artist: "Charlotte OC"),
        TrackDetails(color: Color(hex: "2A2014")!, title: "The Heat", artist: "Khamari"),
        TrackDetails(color: Color(hex: "4D4C4A")!, title: "Vogue (NICOLAAS Remix)", artist: "Madonna"),
        TrackDetails(color: Color(hex: "F1B95C")!, title: "Heavy (Icarus Remix)", artist: "Bow Anderson"),
        TrackDetails(color: Color(hex: "0000D2")!, title: "Way Too Long (Feat Foley)", artist: "Health Club"),
        TrackDetails(color: Color(hex: "264A64")!, title: "You", artist: "Ross Quinn"),
        TrackDetails(color: Color(hex: "00B6C4")!, title: "Maker", artist: "Anjimile"),
        TrackDetails(color: Color(hex: "006CFF")!, title: "Sir Lady Makem Fall", artist: "liv.e"),
        TrackDetails(color: Color(hex: "DEA95D")!, title: "Gravity", artist: "Diggs Duke"),
        TrackDetails(color: Color(hex: "020200")!, title: "Faith", artist: "I Break Horses"),
        TrackDetails(color: Color(hex: "0E0000")!, title: "Long in the Tooth", artist: "The Budos Band"),
        TrackDetails(color: Color(hex: "FD185D")!, title: "Say The Word feat. Andie Nora", artist: "Moonbootica"),
        TrackDetails(color: Color(hex: "1D2122")!, title: "Sure Shot", artist: "Bathe"),
        TrackDetails(color: Color(hex: "813154")!, title: "I Wish I Never Saw The Sunshine", artist: "The Ronettes"),
        TrackDetails(color: Color(hex: "84614E")!, title: "I Don't Wanna Be Mad at You", artist: "ELINA ERIKSSON"),
        TrackDetails(color: Color(hex: "6B416F")!, title: "Someday (Robin Guthrie Version)", artist: "Fawns of Love x Robin Guthrie"),
        TrackDetails(color: Color(hex: "73AAC8")!, title: "Lose Your Love", artist: "Dirty Projectors"),
        TrackDetails(color: Color(hex: "F78D1F")!, title: "Fearless", artist: "Jon Hassell"),
        TrackDetails(color: Color(hex: "2E3F6B")!, title: "Broken Satellite", artist: "Hiro Ama"),
        TrackDetails(color: Color(hex: "83C441")!, title: "Bossy Woman", artist: "Tiny Powell"),
        TrackDetails(color: Color(hex: "473E39")!, title: "Little Boots", artist: "Locussolus"),
        TrackDetails(color: Color(hex: "DF8584")!, title: "Dunkirk", artist: "Silverbacks"),
        TrackDetails(color: Color(hex: "E9C86B")!, title: "Time (You and I)", artist: "Khruangbin"),
        TrackDetails(color: Color(hex: "515151")!, title: "Get Happy", artist: "Blue Hawaii"),
        TrackDetails(color: Color(hex: "1E3837")!, title: "In Two", artist: "Blue Hawaii"),
        TrackDetails(color: Color(hex: "FE9894")!, title: "No One Like You", artist: "Blue Hawaii"),
        TrackDetails(color: Color(hex: "E9C86B")!, title: "So We Won’t Forget", artist: "Khruangbin"),
        TrackDetails(color: Color(hex: "FCC10F")!, title: "Emergency Equipment and Exits", artist: "Ganser"),
        TrackDetails(color: Color(hex: "FE0000")!, title: "Set Me Free (Song for a Person Walking Away) (Extended)", artist: "LUXXURY"),
        TrackDetails(color: Color(hex: "1D2943")!, title: "Too Late", artist: "Washed Out"),
        TrackDetails(color: Color(hex: "FE1252")!, title: "I'm Hot (Van She Tech Remix!!!)", artist: "Ajax"),
        TrackDetails(color: Color(hex: "037339")!, title: "Make The World Go Round", artist: "DJ Cassidy feat. R. Kelly"),
        TrackDetails(color: Color(hex: "23336F")!, title: "Jou-tau", artist: "Mong Tong 夢東"),
        TrackDetails(color: Color(hex: "57B8C9")!, title: "Check To Check", artist: "Open Mike Eagle"),
        TrackDetails(color: Color(hex: "12172B")!, title: "Kane Train (feat. Freddie Gibbs)", artist: "Machinedrum"),
        TrackDetails(color: Color(hex: "89C53F")!, title: "Hide From The Sun", artist: "GOAT"),
        TrackDetails(color: Color(hex: "F5FE41")!, title: "THE DIFFERENCE", artist: "John War"),
        TrackDetails(color: Color(hex: "F15757")!, title: "It Feels Right", artist: "DOV"),
        TrackDetails(color: Color(hex: "355DB5")!, title: "Charms feat. KeiyaA", artist: "Armand Hammer"),
        TrackDetails(color: Color(hex: "473E39")!, title: "Gunship", artist: "Locussolus"),
        TrackDetails(color: Color(hex: "000000")!, title: "Family Secrets (Intro)", artist: "Conway The Machine"),
        TrackDetails(color: Color(hex: "002538")!, title: "Headless Horseman", artist: "The Microphones"),
        TrackDetails(color: Color(hex: "F6F3EA")!, title: "patience (prod. absent avery)", artist: "lojii"),
        TrackDetails(color: Color(hex: "EA3256")!, title: "Wave Funk", artist: "DMX Krew"),
        TrackDetails(color: Color(hex: "EF1E1A")!, title: "Dancing Star", artist: "LILIES ON MARS"),
    ]
    
}
