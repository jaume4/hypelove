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
    @EnvironmentObject var playingState: PlayingState
    @Environment(\.colorScheme) var colorScheme
    @State var transition = false
    let playerPosition: Namespace.ID
    
    var body: some View {
        
        HStack {
            TrackView(track: .constant(playingState.currentTrack), showPlayingBackground: false)
            
            Button(action: {
                playingState.playing.toggle()
            }, label: {
                Image(systemName: playingState.playing ? "pause.fill" : "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                    .padding(.leading, 10)
            })
            .accentColor(.primary)
            
            Button(action: {
                playingState.next()
            }, label: {
                Image(systemName: "forward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                    .padding([.leading, .trailing], 15)
            })
            .accentColor(.primary)
            
        }
        .padding(.bottom, 5)
        .padding(.top, 10)
        
        .matchedGeometryEffect(id: PlayerStatus.shown, in: playerPosition, properties: .position, anchor: .top)
        .matchedGeometryEffect(id: PlayerStatus.hidden, in: playerPosition, properties: .position, anchor: transition ? .bottom : .top, isSource: false)
        
        .transition(AnyTransition.move(edge: Edge.bottom).animation(Animation.easeInOut(duration: 0.2)).combined(with: .opacity))
        .animation(.easeInOut(duration: 0.2))
        
        .onAppear {
            transition = true
        }
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
            NowPlayingView(playerPosition: nameSpace)
                .environmentObject(PlayingState.songPaused)
        }
        .previewLayout(PreviewLayout.fixed(width: 400, height: 100))
        VStack {
            Spacer()
            NowPlayingView(playerPosition: nameSpace)
                .environmentObject(PlayingState.songPlaying)
        }
        .previewLayout(PreviewLayout.fixed(width: 400, height: 100))
    }
}
#endif
