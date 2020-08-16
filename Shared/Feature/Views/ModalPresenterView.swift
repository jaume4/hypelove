//
//  ModalPresenterView.swift
//  HypeLove
//
//  Created by Jaume on 16/08/2020.
//

import SwiftUI

struct ModalPresenterView: View {
    
    @EnvironmentObject var userState: UserState
    
    @ViewBuilder
    var body: some View {
        switch userState.modalToPresent {
        case .settings:
            NavigationView {
                SettingsView(viewModel: SettingsViewModel(userState: userState))
            }
        case .player:
            FullPlayerView()
        }

    }
}
