//
//  NowPlayingView.swift
//  HypeLove
//
//  Created by Jaume on 10/08/2020.
//

import SwiftUI

struct NowPlayingView: View {
    @EnvironmentObject var playingState: PlayingState
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        
        HStack {
            if let track = playingState.currentTrack {
                TrackView(track: .constant(track), showPlayingBackground: false)
            }
            Button(action: {
                playingState.playing.toggle()
            }, label: {
                Image(systemName: playingState.playing ? "pause.fill" : "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                    .padding(.leading, 10)
            }).accentColor(.primary)
            Button(action: {
                playingState.next()
            }, label: {
                Image(systemName: "forward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                    .padding([.leading, .trailing], 15)
            }).accentColor(.primary)
        }
        .padding(.bottom, 5)
        .background(
            VisualEffectBlur(blurStyle: colorScheme == .dark ? .dark : .light)
                .cornerRadius(20)
                .padding(.bottom, -6)
                .padding(.top, -10)
                .edgesIgnoringSafeArea(.bottom)
        )
    }
}

#if DEBUG
struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            NowPlayingView()
                .environmentObject(PlayingState.songPaused)
        }
        .previewLayout(PreviewLayout.fixed(width: 400, height: 100))
        VStack {
            Spacer()
            NowPlayingView()
                .environmentObject(PlayingState.songPlaying)
        }
        .previewLayout(PreviewLayout.fixed(width: 400, height: 100))
    }
}
#endif
