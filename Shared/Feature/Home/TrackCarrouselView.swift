//
//  TrackCarrouselView.swift
//  HypeLove
//
//  Created by Jaume on 11/08/2020.
//

import SwiftUI

struct TrackCarrouselView: View {
    
    @ObservedObject var viewModel: PopularViewModel
    @EnvironmentObject var dataStore: TracksDataStore
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(viewModel.tracks.prefix(10)) { track in
                    TrackCarrouselElementView(track: track)
                        .redacted(reason: viewModel.placeholder ? .placeholder : [])
                }
            }
        }
    }
}

struct TrackCarrouselView_Previews: PreviewProvider {
    
    static let store = TracksDataStore()
    static let userState = UserState()
    
    static var previews: some View {
        VStack {
            TrackCarrouselView(viewModel: PopularViewModel(store: store, mode: .now, bindModeChange: false))
            TrackCarrouselView(viewModel: PopularViewModel(store: store, mode: .now, bindModeChange: false))
                .redacted(reason: .placeholder)
        }
        .environmentObject(store)
        .environmentObject(userState)
    }
}
