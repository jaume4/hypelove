//
//  HypeLoveApp.swift
//  Shared
//
//  Created by Jaume on 06/08/2020.
//

import SwiftUI

enum HomeTab: Hashable {
    case home, popular, favorites, history
}

@main
struct HypeLoveApp: App {
    @StateObject private var userState = UserState()
    @StateObject private var playingState = PlayingState()
    @StateObject private var tracksStore = TracksDataStore()
    
    init() {
        UITabBar.setBlurAppareance()
        UISegmentedControl.setAppareance()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                TabView(selection: $userState.selectedTab) {
                    
                    NavigationView {
                        HomeView()
                    }
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
                        FavoritesView(viewModel: FavoritesViewModel(store: tracksStore.favorites))
                    }
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Favorites")
                    }
                    .tag(HomeTab.favorites)
                    
                    NavigationView {
                        Color.clear
                    }
                    .tabItem {
                        Image(systemName: "clock.fill")
                        Text("History")
                    }
                    .tag(HomeTab.history)
                    
                }
            }
            .environmentObject(userState)
            .environmentObject(playingState)
            .environmentObject(tracksStore)
            .accentColor(.buttonMain)
            .sheet(isPresented: $userState.presentingSettings) {
                NavigationView {
                    SettingsView(viewModel: SettingsViewModel(userState: userState))
                }
                .environmentObject(userState)
                .environmentObject(playingState)
            }
        }
    }
}
