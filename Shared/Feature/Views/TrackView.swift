//
//  TrackView.swift
//  HypeLove
//
//  Created by Jaume on 08/08/2020.
//

import SwiftUI

struct TrackView: View {
    
    let track: TrackDetails
    @EnvironmentObject var player: Player
    @Environment(\.redactionReasons) var redactionReasons
    @State var playing: Bool
    let showPlayingBackground: Bool
    
    var body: some View {
        ZStack {
            if track == player.currentTrack, redactionReasons.isEmpty, showPlayingBackground {
                Color(.secondarySystemFill).layoutPriority(-1)
            }
            HStack {
                Spacer(minLength: 5)
                ZStack {
                    if redactionReasons.isEmpty {
                        //Color
                        track.color
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 1)
                        //Player
                        if track == player.currentTrack, showPlayingBackground, player.state == .playing {
                            PlayingIndicator()
                                .padding(6)
                                .foregroundColor(.white)
                        }
                    } else { //Placeholder color
                        Color(.systemFill)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 1)
                    }

                }
                .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                .frame(maxHeight: 50)
                .padding(5)
                
                VStack(alignment: .leading) {
                    Text(track.title)
                        .fontWeight(.bold)
                    Text(track.artist)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.secondaryLabel))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#if DEBUG
struct TrackView_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            TrackView(track: TrackDetails.placeholderTracks[0], playing: true, showPlayingBackground: true)
            TrackView(track: TrackDetails.placeholderTracks[1], playing: false, showPlayingBackground: true)
            TrackView(track: TrackDetails.placeholderTracks[2], playing: false, showPlayingBackground: true)
                .redacted(reason: .placeholder)
        }
        .previewLayout(PreviewLayout.fixed(width: 400, height: 400))
        .environmentObject(Player.songPlaying)
    }
}
#endif
