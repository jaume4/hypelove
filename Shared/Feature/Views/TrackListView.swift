//
//  TrackListView.swift
//  HypeLove
//
//  Created by Jaume on 13/08/2020.
//

import SwiftUI

struct TrackListView: View {
    
    @EnvironmentObject var player: Player
    @ObservedObject var downloader: TracksDownloader<TrackListRequest>
    
    var body: some View {
        //Tracks view. First tracks are populated with placeholder tracks, redacted if the downloader has marked them as placeholders
        LazyVGrid(columns: [GridItem(.flexible())]) {
            ForEach(downloader.tracks) { track in
                TrackView(track: track, playing: track == player.currentTrack, showPlayingBackground: true)
                    .modifier(MakeButton {
                        player.play(tracks: downloader.tracks, startIndex: downloader.tracks.firstIndex(of: track))
                    })
                    //If this is the last track, request more tracks
                    .onAppear {
                        if track == downloader.tracks.last {
                            downloader.requestTracks()
                        }
                    }
            }
        }
        .redacted(reason: downloader.placeholderTracks ? .placeholder : [])
        .modifier(ReplaceByError(active: downloader.placeholderTracks,
                                 error: downloader.error,
                                 actionDescription: ", tap to retry.",
                                 action: {
                                    downloader.resetError()
                                    downloader.requestTracks()
                                 }
        ))
        
        //Placeholder for loading tracks, only shown after initial loading on new tracks space
        if !downloader.placeholderTracks, downloader.loading {
            LazyVGrid(columns: [GridItem(.flexible())]) {
                ForEach(TrackDetails.placeholderTracks.prefix(10)) { track in
                    TrackView(track: track, playing: track == player.currentTrack, showPlayingBackground: false)
                }
            }
            .redacted(reason: .placeholder)
        }
        
        //Error button
        if !downloader.placeholderTracks {
            ErrorButton(error: downloader.error, actionDescription: ", tap to retry.") {
                downloader.resetError()
                downloader.requestTracks()
            }
            .parentGeometry(nil)
        }
        
        // Space for allowing seeing last trask: NowPlaying 50 + 10
        Spacer(minLength: UIScreen.main.bounds.height / 5)
    }
}
