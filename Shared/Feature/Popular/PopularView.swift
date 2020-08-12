//
//  PopularView.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//  Copyright © 2020 Jaume. All rights reserved.
//

import SwiftUI
import Combine

struct PopularView: View {
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var playingState: PlayingState
    @EnvironmentObject var dataStore: TracksDataStore
    @ObservedObject var viewModel: TrackViewerModel
    @State var mode: TrackListMode = .now
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ScrollView {
                
                Picker("", selection: $mode) {
                    Text("Now").tag(TrackListMode.now)
                    Text("Last week").tag(TrackListMode.lastWeek)
                    Text("Remixes").tag(TrackListMode.remix)
                    Text("No remixes").tag(TrackListMode.noRemix)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                //Tracks view
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(viewModel.tracks) { track in
                        TrackView(track: .constant(track), showPlayingBackground: true)
                            .modifier(MakeButton {
                                playingState.play(track: track)
                            })
                            //If this is the last track, request more tracks
                            .onAppear {
                                if track == viewModel.tracks.last {
                                    viewModel.store.requestTracks()
                                }
                            }
                    }
                }
                
                //Placeholder tracks
                if viewModel.loading {
                    LazyVGrid(columns: [GridItem(.flexible())]) {
                        ForEach(TrackDetails.placeholderTracks) { track in
                            TrackView(track: .constant(track), showPlayingBackground: false)
                        }
                    }
                    .redacted(reason: .placeholder)
                }
                
                //Error button
                ErrorButton(error: viewModel.error, actionDescription: ", tap to retry.") {
                    viewModel.store.resetError()
                    viewModel.store.requestTracks()
                }
                
                // Space for allowing seeing last trask: NowPlaying 50 + 10
                Spacer()
                    .frame(height: 60)
            }
            
            //Now Playing on top of ZStack
            if playingState.currentTrack != nil {
                NowPlayingView()
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                    .animation(.easeInOut(duration: 0.2))
            }
        }
        .onAppear {
            if viewModel.tracks.isEmpty {
                viewModel.store.requestTracks()
            }
        }
        .onChange(of: mode) {
            viewModel.replace(store: dataStore.store(for: $0))
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
    
    static let store = TracksDataStore()
    
    static var previews: some View {
        NavigationView {
            PopularView(viewModel: TrackViewerModel(store: store.store(for: .now)))
        }
        .accentColor(.buttonMain)
        .environmentObject(UserState())
        .environmentObject(PlayingState.songPlaying)
        .environmentObject(TracksDataStore())
        
        NavigationView {
            PopularView(viewModel: TrackViewerModel(store: store.store(for: .now)))
        }
        .redacted(reason: .placeholder)
        .accentColor(.buttonMain)
        .environmentObject(UserState())
        .environmentObject(PlayingState.songPlaying)
        .environmentObject(TracksDataStore())
    }
}
#endif
