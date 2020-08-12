//
//  TrackCarrouselView.swift
//  HypeLove
//
//  Created by Jaume on 11/08/2020.
//

import SwiftUI

final class TrackCarrouselViewModel: ObservableObject {
    @Published var tracks: [TrackDetails] = []
    @Published var placholder: Bool = true
}

struct TrackCarrouselView: View {
    
    @StateObject var viewModel = TrackCarrouselViewModel()
    @EnvironmentObject var dataStore: TracksDataStore
    let mode: TrackListMode?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(viewModel.tracks.prefix(10)) { track in
                    TrackCarrouselElementView(track: track)
                        .redacted(reason: viewModel.placholder ? .placeholder : [])
                }
            }
        }
        .onAppear {
            dataStore.store(for: mode).$tracks.assign(to: &viewModel.$tracks)
            dataStore.store(for: mode).$placeholderTracks.assign(to: &viewModel.$placholder)
        }
    }
}

struct TrackCarrouselView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TrackCarrouselView(mode: nil)
            TrackCarrouselView(mode: nil)
                .redacted(reason: .placeholder)
        }
        .environmentObject(TracksDataStore())
    }
}
