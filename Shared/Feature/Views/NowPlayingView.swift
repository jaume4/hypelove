//
//  NowPlayingView.swift
//  HypeLove
//
//  Created by Jaume on 10/08/2020.
//

import SwiftUI

enum PlayerStatus {
    case hidden, shown
}

struct NowPlayingView: View {
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var player: Player
    @Environment(\.colorScheme) var colorScheme
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 50)
            .onEnded { _ in
                userState.presentPlayer()
            }
    }
    
    var body: some View {
        
        HStack {
            if let track = player.currentTrack {
                TrackView(track: track, playing: track == player.currentTrack, showPlayingBackground: false)
                    .modifier(MakeButton(action: { userState.presentPlayer() }))
            }
            
            Button(action: {
                player.playPause()
            }, label: {
                Image(systemName: player.state != .paused ? "pause.fill" : "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                    .padding(.leading, 10)
            })
            .accentColor(.primary)
            
            Button(action: {
                player.nextTrack()
            }, label: {
                Image(systemName: "forward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                    .padding([.leading, .trailing], 15)
            })
            .accentColor(.primary)
            
        }
        .padding(.top, 10)
        
        .gesture(drag)
    }
}

struct RoundedRectangleCustomCorners: Shape {

    var cornerRadius: CGFloat
    var roundedCorners: UIRectCorner
    var style: RoundedCornerStyle = .continuous

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: roundedCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return Path(path.cgPath)
    }
}

#if DEBUG
struct NowPlayingView_Previews: PreviewProvider {
    @Namespace static var nameSpace
    static var previews: some View {
        VStack {
            Spacer()
            NowPlayingView()
                .environmentObject(Player.songPaused)
        }
        .previewLayout(PreviewLayout.fixed(width: 400, height: 100))
        VStack {
            Spacer()
            NowPlayingView()
                .environmentObject(Player.songPlaying)
        }
        .previewLayout(PreviewLayout.fixed(width: 400, height: 100))
    }
}
#endif
