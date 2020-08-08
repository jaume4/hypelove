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
    
    var body: some View {
        HStack {
            ZStack {
                track.color
                if isPlaying {
                    Image(systemName: "play.fill")
                        .resizable()
                        .padding()
                        .foregroundColor(.white)
                        .opacity(0.7)
                }
            }.aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
            .frame(maxHeight: 50)
            VStack(alignment: .leading) {
                Text(track.title)
                    .lineLimit(1)
                Text(track.artist)
                    .lineLimit(1)
                    .foregroundColor(.gray)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct TrackView_Previews: PreviewProvider {
    
    static let trackDetail = TrackDetails(color: Color.red, title: "Let You Know (feat. London Grammar)", artist: "Flume")
    
    static var previews: some View {
        TrackView(track: trackDetail, isPlaying: true)
            .previewLayout(PreviewLayout.fixed(width: 400, height: 400))
    }
}
