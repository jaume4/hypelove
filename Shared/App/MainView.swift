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
                        .matchedGeometryEffect(id: PlayerStatus.hidden, in: playerPosition, properties: .position, anchor: .bottom, isSource: true)
                        .modifier(PlayerBlurBar(playerPosition: playerPosition))
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(HomeTab.home)
                
                NavigationView {
                    PopularView(viewModel: PopularViewModel(store: tracksStore, mode: .now, bindModeChange: true))
                        .modifier(PlayerBlurBar(playerPosition: playerPosition))
                }
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Popular")
                }
                .tag(HomeTab.popular)
                
                NavigationView {
                    SimpleTrackListView(viewModel: SimpleTrackListViewModel(store: tracksStore.favorites), mode: .favorites)
                        .modifier(PlayerBlurBar(playerPosition: playerPosition))
                }
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
                .tag(HomeTab.favorites)
                
                NavigationView {
                    SimpleTrackListView(viewModel: SimpleTrackListViewModel(store: tracksStore.history), mode: .history)
                        .modifier(PlayerBlurBar(playerPosition: playerPosition))
                }
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }
                .tag(HomeTab.history)
                
            }
            
            //Now Playing on top of ZStack
            if player.currentTrack != nil {
                VStack {
                    Spacer()
                    NowPlayingView(playerPosition: playerPosition)
                }
            }
        }
        
        .sheet(isPresented: $userState.presentingModal) {
            ModalPresenterView()
            .environmentObject(userState)
            .environmentObject(player)
        }
    }
}
