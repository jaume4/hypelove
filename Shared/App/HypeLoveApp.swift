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
    @StateObject private var popularDataStore = TracksDataStore()
    
    init() {
        UITabBar.setBlurAppareance()
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
                        PopularView()
                    }
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Popular")
                    }
                    .tag(HomeTab.popular)
                    
                    NavigationView {
                        Color.clear
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
            .environmentObject(popularDataStore)
            .accentColor(.buttonMain)
            .sheet(isPresented: $userState.presentingSettings) {
                LoginView(viewModel: LoginViewModel(userState: userState))
                    .environmentObject(userState)
                    .environmentObject(playingState)
            }
        }
    }
}
