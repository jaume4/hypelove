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
                
                //Popular now title
                VStack(alignment: .leading) {
                    HStack {
                        Text(PopularMode.now.title)
                            .frame(alignment: .leading)
                            .padding()
                        Spacer(minLength: 0)
                        Image(systemName: "chevron.right")
                            .padding()
                    }
                    .font(Font.title2.bold())
                }
                .modifier(MakeButton {
                    store.popularMode = .now
                    userState.selectedTab = .popular
                })
                
                //Popular now carrousel
                TrackCarrouselView(downloader: store.popular)
                    .onAppear {
                        store.popular.requestTracksIfEmpty()
                    }
                
                //Popular last week title
                VStack(alignment: .leading) {
                    HStack {
                        Text(PopularMode.lastWeek.title)
                            .frame(alignment: .leading)
                            .padding()
                        Spacer(minLength: 0)
                        Image(systemName: "chevron.right")
                            .padding()
                    }
                    .font(Font.title2.bold())
                }
                .modifier(MakeButton {
                    store.popularMode = .lastWeek
                    userState.selectedTab = .popular
                })
                
                //Popular last week carrousel
                TrackCarrouselView(downloader: store.lastWeek)
                    .onAppear {
                        store.lastWeek.requestTracksIfEmpty()
                    }
                
                //Feed title
                VStack(alignment: .leading) {
                    HStack {
                        Text("Feed")
                            .font(Font.title2.bold())
                            .frame(alignment: .leading)
                            .padding()
                        Spacer(minLength: 0)
                    }
                }
                
                //Feed carrousel
                TrackCarrouselView(downloader: store.feed)
                    .onAppear {
                        store.feed.requestTracksIfEmpty()
                    }
                
                VStack(spacing: 15) {
                    NavigationLink(destination: SimpleTrackListView(tracksDownloader: store.new, mode: .new(.all)), tag: TracksMode.new(.all), selection: $destination) {
                        Text("New")
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
                                        Button(action: userState.presentSettings,
                                            label: {
                                            Image(systemName: "gear")
                                        })
                                    }
                                    .unredacted()
            )
            .onChange(of: destination) { newDestination in
                userState.hiddenTabBar = newDestination != nil
            }
            
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
