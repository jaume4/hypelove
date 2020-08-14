//
//  SimpleTrackListView.swift
//  HypeLove
//
//  Created by Jaume on 13/08/2020.
//

import SwiftUI

struct SimpleTrackListView: View {
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var playingState: PlayingState
    @EnvironmentObject var dataStore: TracksDataStore
    @StateObject var viewModel: SimpleTrackListViewModel
    let mode: TracksEndPoint
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            GeometryReader { proxy in
                
                ScrollView {
                    
                    TrackListView(tracks: $viewModel.tracks,
                                  loading: $viewModel.loading,
                                  placeHolderTracks: $viewModel.placeholder,
                                  error: $viewModel.error,
                                  requestTracks: viewModel.requestTracks,
                                  resetError: viewModel.resetError)
                        .padding([.top], 10)
                }
                .modifier(ReplaceByError(active: viewModel.error == .notAuthorized,
                                         error: viewModel.error,
                                         actionDescription: ", tap to open settings.",
                                         action: {
                                            userState.presentingSettings.toggle()
                                         }
                ))
                .parentGeometry(proxy)
            }
        }
        
        .onChange(of: userState.selectedTab) { tab in
            guard tab == .favorites else { return }
            viewModel.requestTracksIfEmpty()
        }
        
        .onChange(of: userState.validToken) { validToken in
            if validToken, viewModel.error == .notAuthorized {
                viewModel.resetError()
                viewModel.requestTracks()
            } else if !validToken {
                viewModel.resetTracks()
                viewModel.error = .notAuthorized
            }
        }
        
        .navigationTitle(mode.title)
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
            SimpleTrackListView(viewModel: SimpleTrackListViewModel(store: store.favorites), mode: .history)
        }
        .accentColor(.buttonMain)
        .environmentObject(userState)
        .environmentObject(PlayingState.songPlaying)
        .environmentObject(TracksDataStore())
        
        NavigationView {
            SimpleTrackListView(viewModel: SimpleTrackListViewModel(store: store.favorites), mode: .history)
        }
        .redacted(reason: .placeholder)
        .accentColor(.buttonMain)
        .environmentObject(UserState())
        .environmentObject(PlayingState.songPlaying)
        .environmentObject(TracksDataStore())
    }
}
