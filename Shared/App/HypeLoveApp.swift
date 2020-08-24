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
    @StateObject private var player = Player()
    @StateObject private var tracksStore = TracksDataStore()
    
    init() {
        UITabBar.setBlurAppareance()
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
