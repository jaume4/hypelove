//
//  HomeView.swift
//  HypeLove
//
//  Created by Jaume on 09/08/2020.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var store: TracksDataStore
    
    var body: some View {
        
        ScrollView {
            LazyVStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Popular now")
                            .frame(alignment: .leading)
                            .padding()
                        Spacer(minLength: 0)
                        Image(systemName: "chevron.right")
                            .padding()
                    }
                    .font(Font.title2.bold())
                }
                .modifier(MakeButton {
                    print("Popular now")
                })
                TrackCarrouselView(viewModel: TrackViewerModel(store: store.store(for: .now)))
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Popular last week")
                            .font(Font.title2.bold())
                            .frame(alignment: .leading)
                            .padding()
                        Spacer(minLength: 0)
                    }
                }
                TrackCarrouselView(viewModel: TrackViewerModel(store: store.store(for: .lastWeek)))
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Feed")
                            .font(Font.title2.bold())
                            .frame(alignment: .leading)
                            .padding()
                        Spacer(minLength: 0)
                    }
                }
                TrackCarrouselView(viewModel: TrackViewerModel(store: store.store(for: .remix)))
                
                VStack(spacing: 15) {
                    Button("New") {
                        print("New")
                    }
                    Button("Artists") {
                        print("Artists")
                    }
                    Button("Blogs") {
                        print("Blogs")
                    }
                }
                .padding()
                .buttonStyle(HypeButton())
                
            }
            .navigationTitle("Home")
            .navigationBarItems(trailing:
                                    HStack(spacing: 25) {
                                        Button(action: {}, label: {
                                            Image(systemName: "magnifyingglass")
                                        })
                                        Button(action: {
                                            userState.presentingSettings.toggle()
                                        }, label: {
                                            Image(systemName: "gear")
                                        })
                                    }
                                    .unredacted()
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
        .accentColor(.buttonMain)
        .environmentObject(UserState())
        .environmentObject(TracksDataStore())
        
        NavigationView {
            HomeView()
        }
        .accentColor(.buttonMain)
        .preferredColorScheme(.dark)
        .environmentObject(UserState())
        .environmentObject(TracksDataStore())
    }
}
