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
        Text("Hello \(userState.userName)")
            .onAppear {
                viewModel.requestTracks()
            }
    }
}

struct PopularView_Previews: PreviewProvider {
    static var previews: some View {
        PopularView()
            .environmentObject(UserState())
    }
}
