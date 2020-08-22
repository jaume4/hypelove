//
//  TrackCarrouselView.swift
//  HypeLove
//
//  Created by Jaume on 11/08/2020.
//

import SwiftUI

struct TrackCarrouselView: View {
    
    @EnvironmentObject var userState: UserState
    @StateObject var downloader: TracksDownloader<TrackListRequest>
    @EnvironmentObject var player: Player
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(downloader.tracks.prefix(10)) { track in
                    TrackCarrouselElementView(track: track, imageDownloader: ImageDownloader(track.imageURL, placeholder: downloader.placeholderTracks))
                        .redacted(reason: downloader.placeholderTracks ? .placeholder : [])
                        .modifier(MakeButton {
                            player.play(tracks: downloader.tracks, startIndex: downloader.tracks.firstIndex(of: track))
                        })
                }
            }
        }
        .modifier(ReplaceByError(active: downloader.placeholderTracks && downloader.error != nil && downloader.error != .notAuthorized,
                                 error: downloader.error,
                                 actionDescription: ", tap to retry.",
                                 action: {
                                    downloader.resetError()
                                    downloader.requestTracks()
                                 }
        ))
        .modifier(ReplaceByError(active: downloader.error == .notAuthorized,
                                 error: downloader.error,
                                 actionDescription: ", tap to open settings.",
                                 action: userState.presentSettings)
        )
    }
}

struct TrackCarrouselView_Previews: PreviewProvider {

    static let store = TracksDataStore()
    static let userState = UserState()

    static var previews: some View {
        VStack {
            TrackCarrouselView(downloader: store.popular)
            TrackCarrouselView(downloader: store.popular)
                .redacted(reason: .placeholder)
        }
        .environmentObject(store)
        .environmentObject(userState)
    }
}
