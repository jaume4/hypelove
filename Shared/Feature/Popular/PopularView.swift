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
    @StateObject var viewModel: PopularViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ScrollView {
                
                Picker("", selection: $viewModel.store.popularMode) {
                    Text("Now").tag(PopularMode.now)
                    Text("Last week").tag(PopularMode.lastWeek)
                    Text("Remixes").tag(PopularMode.remix)
                    Text("No remixes").tag(PopularMode.noRemix)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                TrackListView(tracks: $viewModel.tracks,
                              loading: $viewModel.loading,
                              placeHolderTracks: $viewModel.placeholder,
                              error: $viewModel.error,
                              requestTracks: viewModel.requestTracks,
                              resetError: viewModel.resetError)
                
                
                
            }
            
            //Now Playing on top of ZStack
            if playingState.currentTrack != nil {
                NowPlayingView()
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                    .animation(.easeInOut(duration: 0.2))
            }
            
        }
        .navigationTitle(viewModel.store.popularMode.title)
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
    
    static let userState = UserState()
    static let store = TracksDataStore()
    
    static var previews: some View {
        NavigationView {
            PopularView(viewModel: PopularViewModel(store: store, mode: .now))
        }
        .accentColor(.buttonMain)
        .environmentObject(userState)
        .environmentObject(PlayingState.songPlaying)
        .environmentObject(TracksDataStore())
        
        NavigationView {
            PopularView(viewModel: PopularViewModel(store: store, mode: .now))
        }
        .redacted(reason: .placeholder)
        .accentColor(.buttonMain)
        .environmentObject(UserState())
        .environmentObject(PlayingState.songPlaying)
        .environmentObject(TracksDataStore())
    }
}
#endif
