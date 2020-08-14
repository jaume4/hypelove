//
//  FavoritesView.swift
//  HypeLove
//
//  Created by Jaume on 13/08/2020.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var playingState: PlayingState
    @EnvironmentObject var dataStore: TracksDataStore
    @StateObject var viewModel: FavoritesViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ScrollView {
                
                TrackListView(tracks: $viewModel.tracks,
                              loading: $viewModel.loading,
                              placeHolderTracks: $viewModel.placeholder,
                              error: $viewModel.error,
                              requestTracks: viewModel.requestTracks,
                              resetError: viewModel.resetError)
                    .padding([.top], 10)
            }
            .modifier(ReplaceByError(active: viewModel.error == .notAuthorized, error: viewModel.error, actionDescription: ", tap to open settings.", action: { userState.presentingSettings.toggle() }))
            
        }
        .onChange(of: userState.selectedTab) { tab in
            guard tab == .favorites else { return }
            viewModel.requestTracksIfEmpty()
        }
        .navigationTitle("Favorites")
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

struct FavoritesView_Previews: PreviewProvider {
    static let userState = UserState()
    static let store = TracksDataStore()
    
    static var previews: some View {
        NavigationView {
            FavoritesView(viewModel: FavoritesViewModel(store: store.favorites))
        }
        .accentColor(.buttonMain)
        .environmentObject(userState)
        .environmentObject(PlayingState.songPlaying)
        .environmentObject(TracksDataStore())
        
        NavigationView {
            FavoritesView(viewModel: FavoritesViewModel(store: store.favorites))
        }
        .redacted(reason: .placeholder)
        .accentColor(.buttonMain)
        .environmentObject(UserState())
        .environmentObject(PlayingState.songPlaying)
        .environmentObject(TracksDataStore())
    }
}
