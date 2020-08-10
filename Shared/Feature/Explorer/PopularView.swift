//
//  PopularView.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//  Copyright © 2020 Jaume. All rights reserved.
//

import SwiftUI

struct PopularView: View {
    @EnvironmentObject var userState: UserState
    @StateObject var viewModel = PopularViewModel()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())]) {
                ForEach(viewModel.tracks) { track in
                    TrackView(track: track)
                }
            }
        }
        .redacted(reason: viewModel.tracksCancellable == nil ? [] : .placeholder)
        .onAppear {
            viewModel.requestTracks()
        }
    }
}

struct PopularView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PopularView(viewModel: viewModel)
        }
        .environmentObject(UserState())
    }
    
    static let viewModel: PopularViewModel = {
        let viewModel = PopularViewModel()
        viewModel.tracks = TrackDetails.placeholderTracks
        return viewModel
    }()
}
