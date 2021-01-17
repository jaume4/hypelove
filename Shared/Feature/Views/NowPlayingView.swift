//
//  NowPlayingView.swift
//  HypeLove
//
//  Created by Jaume on 10/08/2020.
//

import SwiftUI

enum NowPlaying {
    case location
}

struct NowPlayingView: View {
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var player: Player
    @Environment(\.colorScheme) var colorScheme
    @State var transition = false
    let playerPosition: Namespace.ID
    
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
                    .font(.caption)
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
        .padding(.bottom, 5)
        .padding(.top, 10)
        
        .gesture(drag)
        
        .background(VisualEffectBlur(blurStyle: .systemThickMaterial).ignoresSafeArea(.all, edges: .bottom)
                        .clipShape(RoundedRectangleCustomCorners(cornerRadius: 20, roundedCorners: [.topLeft, .topRight]))
                        .ignoresSafeArea(.all, edges: .all)
        
        )
        
        .matchedGeometryEffect(id: NowPlaying.location, in: playerPosition, properties: .position, anchor: transition ? .bottom : .top, isSource: false)
        
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
                .environmentObject(Player.songPaused)
        }
        .previewLayout(PreviewLayout.fixed(width: 400, height: 100))
        VStack {
            Spacer()
            NowPlayingView(playerPosition: nameSpace)
                .environmentObject(Player.songPlaying)
        }
        .previewLayout(PreviewLayout.fixed(width: 400, height: 100))
    }
}
#endif
