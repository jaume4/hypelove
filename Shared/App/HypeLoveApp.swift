//
//  HypeLoveApp.swift
//  Shared
//
//  Created by Jaume on 06/08/2020.
//

import SwiftUI

@main
struct HypeLoveApp: App {
    @StateObject private var userState = UserState()
    @StateObject private var playingState = PlayingState()
    
    init() {
        UITabBar.setBlurAppareance()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                TabView {
                    
                    NavigationView {
                        PopularView()
                    }
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Popular")
                    }
                    
                    NavigationView {
                        PopularView()
                    }
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Favorites")
                    }
                    
                    NavigationView {
                        PopularView()
                    }
                    .tabItem {
                        Image(systemName: "clock")
                        Text("Latest")
                    }
                    
                    NavigationView {
                        LoginView(viewModel: LoginViewModel(userState: userState))
                    }
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
            }
            .environmentObject(userState)
            .environmentObject(playingState)
            .accentColor(.buttonMain)
        }
    }
}
