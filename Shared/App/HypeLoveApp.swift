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
    @StateObject private var player = Player()
    @StateObject private var tracksStore = TracksDataStore()
    
    init() {
        UISegmentedControl.setAppareance()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(userState)
                .environmentObject(player)
                .environmentObject(tracksStore)
                .accentColor(.buttonMain)
        }
    }
}
