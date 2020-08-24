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
    @EnvironmentObject var player: Player
    @EnvironmentObject var tracksStore: TracksDataStore
    @Namespace private var playerPosition
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $userState.selectedTab) {
                
                NavigationView {
                    HomeView()
                }
                .matchedGeometryEffect(id: NowPlaying.location, in: playerPosition, properties: .position, anchor: .bottom, isSource: true)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(HomeTab.home)
                
                NavigationView {
                    PopularView(viewModel: PopularViewModel(store: tracksStore, mode: .now, bindModeChange: true))
                }
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Popular")
                }
                .tag(HomeTab.popular)
                
                NavigationView {
                    SimpleTrackListView(tracksDownloader: tracksStore.favorites, mode: .favorites)
                }
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
                .tag(HomeTab.favorites)
                
                NavigationView {
                    SimpleTrackListView(tracksDownloader: tracksStore.history, mode: .history)
                }
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }
                .tag(HomeTab.history)
                
            }
            
            //Now Playing on top of ZStack
            if player.currentTrack != nil {
                NowPlayingView(playerPosition: playerPosition)
            }
        }
        
        .sheet(isPresented: $userState.presentingModal) {
            ModalPresenterView()
            .environmentObject(userState)
            .environmentObject(player)
        }
    }
}
