//
//  PopularView.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//  Copyright © 2020 Jaume. All rights reserved.
//

import SwiftUI

struct PopularView: View {
    @StateObject var viewModel: PopularViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            GeometryReader { proxy in
            
                ScrollView {
                    
                    Picker("", selection: $viewModel.store.popularMode) {
                        Text("Now").tag(PopularMode.now)
                        Text("Last week").tag(PopularMode.lastWeek)
                        Text("Remix").tag(PopularMode.remix)
                        Text("No remix").tag(PopularMode.noRemix)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    
                    TrackListView(downloader: viewModel.trackStore)
                        .parentGeometry(proxy)
                }
            }
            
        }
        
        .navigationTitle(viewModel.store.popularMode.title)
        .navigationBarItems(trailing:
                                HStack(spacing: 25) {
                                    Button(action: {}, label: {
                                        Image(systemName: "magnifyingglass")
                                    })
                                    Button(action: {}, label: {
                                        Image(systemName: "line.horizontal.3.decrease.circle")
                                    })
                                }
                                .unredacted()
                            
        )
    }
}

#if DEBUG
struct PopularView_Previews: PreviewProvider {
    
    static let userState = UserState()
    static let store = TracksDataStore()
    
    static var previews: some View {
        NavigationView {
            PopularView(viewModel: PopularViewModel(store: store, mode: .now, bindModeChange: true))
        }
        .accentColor(.buttonMain)
        .environmentObject(userState)
        .environmentObject(Player.songPlaying)
        .environmentObject(TracksDataStore())
        
        NavigationView {
            PopularView(viewModel: PopularViewModel(store: store, mode: .now, bindModeChange: true))
        }
        .redacted(reason: .placeholder)
        .accentColor(.buttonMain)
        .environmentObject(UserState())
        .environmentObject(Player.songPlaying)
        .environmentObject(TracksDataStore())
    }
}
#endif
