//
//  NowPlayingView.swift
//  HypeLove
//
//  Created by Jaume on 10/08/2020.
//

import SwiftUI

struct NowPlayingView: View {
    @EnvironmentObject var playingState: PlayingState
    
    var body: some View {
        HStack {
            if let track = playingState.currentTrack {
                TrackView(track: track)
                    .disabled(true)
            }
            Button(action: {
                playingState.playing.toggle()
            }, label: {
                Image(systemName: playingState.playing ? "play.fill" : "pause.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
            }).accentColor(.primary)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .padding(.bottom, -6)
                .padding(.top, -10)
                .edgesIgnoringSafeArea(.bottom)
                .shadow(radius: 4)
        )
    }
}

struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            NowPlayingView()
                .environmentObject(PlayingState.songPlaying)
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
