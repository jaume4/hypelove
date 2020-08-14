//
//  MainView.swift
//  HypeLove
//
//  Created by Jaume on 14/08/2020.
//

import Foundation
import SwiftUI

struct MainView: View {
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var playingState: PlayingState
    @EnvironmentObject var tracksStore: TracksDataStore
    @Namespace private var playerPosition
    @State private var currentAnchor = PlayerStatus.hidden
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $userState.selectedTab) {
                
                NavigationView {
                    HomeView()
                        .matchedGeometryEffect(id: PlayerStatus.hidden, in: playerPosition, properties: .position, anchor: .bottom, isSource: true)
                        .modifier(PlayerBlurBar(currentAnchor: $currentAnchor, playerPosition: playerPosition))
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(HomeTab.home)
                
                NavigationView {
                    PopularView(viewModel: PopularViewModel(store: tracksStore, mode: .now, bindModeChange: true))
                        .modifier(PlayerBlurBar(currentAnchor: $currentAnchor, playerPosition: playerPosition))
                }
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Popular")
                }
                .tag(HomeTab.popular)
                
                NavigationView {
                    FavoritesView(viewModel: FavoritesViewModel(store: tracksStore.favorites))
                        .modifier(PlayerBlurBar(currentAnchor: $currentAnchor, playerPosition: playerPosition))
                }
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
                .tag(HomeTab.favorites)
                
                NavigationView {
                    Color.clear
                        .modifier(PlayerBlurBar(currentAnchor: $currentAnchor, playerPosition: playerPosition))
                }
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }
                .tag(HomeTab.history)
                
            }
            
            //Now Playing on top of ZStack
            if playingState.currentTrack != nil {
                VStack {
                    Spacer()
                    NowPlayingView(playerPosition: playerPosition)
                }
            }
        }
        
        .onChange(of: playingState.currentTrack, perform: { value in
            currentAnchor = value != nil ? .shown : .hidden
        })
        
        .sheet(isPresented: $userState.presentingSettings) {
            NavigationView {
                SettingsView(viewModel: SettingsViewModel(userState: userState))
            }
            .environmentObject(userState)
            .environmentObject(playingState)
        }
    }
}
