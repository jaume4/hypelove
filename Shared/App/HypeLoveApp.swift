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
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if userState.validToken {
                    PopularView()
                        .transition(.opacity)
                } else {
                    LoginView()
                        .transition(.opacity)
                }
            }.environmentObject(userState)
        }
    }
}
