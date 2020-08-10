//
//  TrackView.swift
//  HypeLove
//
//  Created by Jaume on 08/08/2020.
//

import SwiftUI

struct TrackView: View {
    
    @State var track: TrackDetails
    @State var isPlaying: Bool = false
    @Environment(\.redactionReasons) var redactionReasons
    
    var body: some View {
        HStack {
            Spacer(minLength: 5)
            ZStack {
                Button(action: {
                    isPlaying.toggle()
                }, label: {
                    track.color
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 1)
                }).disabled(!redactionReasons.isEmpty)
                if isPlaying {
                PlayingIndicator()
                    .padding(6)
                    .foregroundColor(.white)
                }
            }.aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
            .frame(maxHeight: 50)
            .padding(5)
            
            VStack(alignment: .leading) {
                Text(track.title)
                    .fontWeight(.bold)
                Text(track.artist)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct TrackView_Previews: PreviewProvider {
    
    static let trackDetail = TrackDetails(color: Color.red, title: "Let You Know (feat. London Grammar)", artist: "Flume", duration: "3:27")
    
    static var previews: some View {
        VStack {
            TrackView(track: trackDetail, isPlaying: false)
            TrackView(track: trackDetail, isPlaying: true)
            TrackView(track: trackDetail, isPlaying: false)
                .redacted(reason: .placeholder)
        }
        .previewLayout(PreviewLayout.fixed(width: 400, height: 400))
    }
}
