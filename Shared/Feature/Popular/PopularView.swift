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
    @EnvironmentObject var playingState: PlayingState
    @StateObject var viewModel = PopularViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                
                //Tracks view
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(viewModel.tracks) { track in
                        TrackView(track: .constant(track), showPlayingBackground: true)
                            .modifier(MakeButton {
                                playingState.play(track: track)
                            })
                            .onAppear {
                                if track == viewModel.tracks.last {
                                    viewModel.requestTracks()
                                }
                            }
                    }
                }
                
                //Placeholder tracks
                if viewModel.tracksCancellable != nil {
                    LazyVGrid(columns: [GridItem(.flexible())]) {
                        ForEach(viewModel.placeholderTracks) { track in
                            TrackView(track: .constant(track), showPlayingBackground: false)
                        }
                    }
                    .redacted(reason: .placeholder)
                }
                
                //Error button
                ErrorButton(error: viewModel.error, actionDescription: ", tap to retry.") {
                    viewModel.resetError()
                    viewModel.requestTracks()
                }
                
                // Space for allowing seeing last trask: NowPlaying 50 + 10
                Spacer()
                    .frame(height: 60)
            }
            .onAppear {
                if viewModel.tracks.isEmpty {
                    viewModel.requestTracks()
                }
            }
            
            //Now Playing on top of ZStack
            if playingState.currentTrack != nil {
                NowPlayingView()
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                    .animation(.easeInOut(duration: 0.2))
            }
        }
        .navigationTitle("Popular")
        .navigationBarItems(trailing:
                                HStack(spacing: 25) {
                                    Button(action: {}, label: {
                                        Image(systemName: "magnifyingglass")
                                    })
                                    Button(action: {}, label: {
                                        Image(systemName: "line.horizontal.3.decrease.circle")
                                    })
                                }
                                .unredacted()
        )
    }
}

#if DEBUG
struct PopularView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PopularView(viewModel: PopularViewModel.tracksLoaded)
        }
        .environmentObject(UserState())
        .environmentObject(PlayingState.songPlaying)
    }
}
#endif
