//
//  TrackView.swift
//  HypeLove
//
//  Created by Jaume on 08/08/2020.
//

import SwiftUI

struct TrackView: View {
    
    @State var track: TrackDetails
    @EnvironmentObject var playingState: PlayingState
    @Environment(\.redactionReasons) var redactionReasons
    
    var body: some View {
        HStack {
            Spacer(minLength: 5)
            ZStack {
                Button(action: {
                    playingState.currentTrack = track
                }, label: {
                    track.color
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 1)
                }).disabled(!redactionReasons.isEmpty)
                if playingState.currentTrack?.id == track.id && playingState.playing {
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
    
    static var previews: some View {
        VStack {
            TrackView(track: TrackDetails.placeholderTracks[0])
            TrackView(track: TrackDetails.placeholderTracks[1])
            TrackView(track: TrackDetails.placeholderTracks[2])
                .redacted(reason: .placeholder)
        }
        .previewLayout(PreviewLayout.fixed(width: 400, height: 400))
        .environmentObject(PlayingState.songPlaying)
    }
}
