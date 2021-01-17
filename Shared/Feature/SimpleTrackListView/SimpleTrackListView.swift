//
//  SimpleTrackListView.swift
//  HypeLove
//
//  Created by Jaume on 13/08/2020.
//

import SwiftUI

struct SimpleTrackListView: View {
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var player: Player
    @StateObject var tracksDownloader: TracksDownloader<TrackListRequest>
    let mode: TracksMode
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            GeometryReader { proxy in
                
                ScrollView {
                    
                    TrackListView(downloader: tracksDownloader)
                        .padding([.top], 10)
                }
                .modifier(ReplaceByError(active: tracksDownloader.error == .notAuthorized,
                                         error: tracksDownloader.error,
                                         actionDescription: ", tap to open settings.",
                                         action: userState.presentSettings)
                )
                .parentGeometry(proxy)
            }
        }
        
        .onChange(of: userState.selectedTab) { tab in
            guard tab == mode else { return }
            tracksDownloader.requestTracksIfEmpty()
        }
        
        .navigationTitle(mode.title)
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
struct FavoritesView_Previews: PreviewProvider {
    static let userState = UserState()
    static let store = TracksDataStore()
    
    static var previews: some View {
        NavigationView {
            SimpleTrackListView(tracksDownloader: store.favorites, mode: .history)
        }
        .accentColor(.buttonMain)
        .environmentObject(userState)
        .environmentObject(Player.songPlaying)
        .environmentObject(TracksDataStore())
        
        NavigationView {
            SimpleTrackListView(tracksDownloader: store.favorites, mode: .history)
        }
        .redacted(reason: .placeholder)
        .accentColor(.buttonMain)
        .environmentObject(UserState())
        .environmentObject(Player.songPlaying)
        .environmentObject(TracksDataStore())
    }
}
#endif
