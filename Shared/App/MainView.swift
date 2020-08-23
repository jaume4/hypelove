//
//  MainView.swift
//  HypeLove
//
//  Created by Jaume on 23/08/2020.
//

import Foundation
import SwiftUI

enum CurrentTab: String, Hashable, CaseIterable {
    case home, popular, favorites, history
}

struct MainView: View {
    
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var player: Player
    @EnvironmentObject var tracksStore: TracksDataStore
    @State var tab: CurrentTab = .home
    
    @ViewBuilder
    func content(tab: CurrentTab) -> some View {
        
        switch tab {
        case .home:
            NavigationView {
                HomeView()
            }
        case .popular:
            NavigationView {
                PopularView(viewModel: PopularViewModel(store: tracksStore, mode: .now, bindModeChange: true))
            }
        case .favorites:
            NavigationView {
                SimpleTrackListView(tracksDownloader: tracksStore.favorites, mode: .favorites)
            }
        case .history:
            NavigationView {
                SimpleTrackListView(tracksDownloader: tracksStore.history, mode: .history)
            }
        }
    }
    
    @ViewBuilder
    func button(tab: CurrentTab) -> some View {
        VStack {
            switch tab {
            case .home:
                Image(systemName: "house.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("Home")
            case .popular:
                Image(systemName: "chart.bar.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("Popular")
            case .favorites:
                Image(systemName: "heart.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("Favorites")
            case .history:
                Image(systemName: "clock.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("History")
            }
        }
        
        .font(Font.caption2)

    }

    
    var body: some View {
        MusicTabView($tab, hiddenTabBar: $userState.hiddenTabBar, content: content, tabs: button)
            .sheet(isPresented: $userState.presentingModal) {
                ModalPresenterView()
                    .environmentObject(userState)
                    .environmentObject(player)
            }
    }
    
}
