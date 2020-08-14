//
//  TrackListView.swift
//  HypeLove
//
//  Created by Jaume on 13/08/2020.
//

import SwiftUI

struct TrackListView<T: RawRepresentable>: View where T.RawValue == String {
    
    @EnvironmentObject var playingState: PlayingState
    @Binding var tracks: [TrackDetails]
    @Binding var loading: Bool
    @Binding var placeHolderTracks: Bool
    @Binding var error: NetworkError<T>?
    
    let requestTracks: () -> ()
    let resetError: () -> ()
    
    var body: some View {
        //Tracks view. First tracks are populated with placeholder tracks, redacted if the downloader has marked them as placeholders
        LazyVGrid(columns: [GridItem(.flexible())]) {
            ForEach(tracks) { track in
                TrackView(track: .constant(track), showPlayingBackground: true)
                    .modifier(MakeButton {
                        playingState.play(track: track)
                    })
                    //If this is the last track, request more tracks
                    .onAppear {
                        if track == tracks.last {
                            requestTracks()
                        }
                    }
            }
        }
        .redacted(reason: placeHolderTracks ? .placeholder : [])
        .modifier(ReplaceByError(active: placeHolderTracks,
                                 error: error,
                                 actionDescription: ", tap to retry.",
                                 action: {
                                    resetError()
                                    requestTracks()
                                 }
        ))
        
        //Placeholder for loading tracks, only shown after initial loading on new tracks space
        if !placeHolderTracks, loading {
            LazyVGrid(columns: [GridItem(.flexible())]) {
                ForEach(TrackDetails.placeholderTracks) { track in
                    TrackView(track: .constant(track), showPlayingBackground: false)
                }
            }
            .redacted(reason: .placeholder)
        }
        
        //Error button
        if !placeHolderTracks {
            ErrorButton(error: error, actionDescription: ", tap to retry.") {
                resetError()
                requestTracks()
            }
            .parentGeometry(nil)
        }
        
        // Space for allowing seeing last trask: NowPlaying 50 + 10
        Spacer()
            .frame(height: 60)
    }
}
