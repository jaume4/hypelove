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
    @State var destination: TracksMode?
    
    var body: some View {
        
        ScrollView {
            LazyVStack {
                
                //Popular now
                HeaderView(title: TracksMode.popular(.now).title) {
                    store.popularMode = .now
                    userState.selectedTab = .popular
                }
                
                TrackCarrouselView(downloader: store.popular)
                
                //Popular last week
                HeaderView(title: TracksMode.popular(.lastWeek).title) {
                    store.popularMode = .lastWeek
                    userState.selectedTab = .popular
                }
                
                TrackCarrouselView(downloader: store.lastWeek)
                
                //New
                NavigationLink(destination: SimpleTrackListView(tracksDownloader: store.new, mode: .new(.all)), tag: TracksMode.new(.all), selection: $destination) {
                    HeaderView(title: TracksMode.new(.all).title) {
                        destination = .new(.all)
                    }
                }
                
                TrackCarrouselView(downloader: store.new)
                
                NavigationLink(destination: SimpleTrackListView(tracksDownloader: store.feed, mode: .feed), tag: TracksMode.feed, selection: $destination) {
                    HeaderView(title: TracksMode.feed.title) {
                        destination = .feed
                    }
                }
                
                TrackCarrouselView(downloader: store.feed)
                
                
                VStack(spacing: 15) {
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
                                        Button(action: userState.presentSettings,
                                            label: {
                                            Image(systemName: "gear")
                                        })
                                    }
                                    .unredacted()
            )
            
            Spacer(minLength: UIScreen.main.bounds.height / 5)
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
