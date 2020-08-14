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
                TrackCarrouselView(viewModel: PopularViewModel(store: store, mode: .now, bindModeChange: false))
                    .onAppear {
                        store.store(for: .now).requestTracksIfEmpty()
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
                TrackCarrouselView(viewModel: PopularViewModel(store: store, mode: .lastWeek, bindModeChange: false))
                    .onAppear {
                        store.store(for: .lastWeek).requestTracksIfEmpty()
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
                TrackCarrouselView(viewModel: PopularViewModel(store: store, mode: .remix, bindModeChange: false))
                    .onAppear {
                        store.store(for: .remix).requestTracksIfEmpty()
                    }
                
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
