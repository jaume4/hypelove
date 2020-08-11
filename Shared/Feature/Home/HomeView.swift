//
//  HomeView.swift
//  HypeLove
//
//  Created by Jaume on 09/08/2020.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    Button("Popular") {
                        print("tap popular")
                    }
                    Button("Recent") {
                        print("tap recent")
                    }
                    Button("New") {
                        print("tap recent")
                    }
                    Button("Favorites") {
                        print("tap recent")
                    }
                }
                .padding()
                .buttonStyle(HypeButton())
                HStack {
                    Text("Playing now")
                        .font(.title3)
                        .frame(alignment: .leading)
                        .padding()
                    Spacer()
                }
                PopularView()
            }
            .navigationTitle("Home")
            .navigationBarItems(trailing:
                                    HStack(spacing: 25) {
                                        Button(action: {}, label: {
                                            Image(systemName: "magnifyingglass")
                                        })
                                        Button(action: {}, label: {
                                            Image(systemName: "gear")
                                        })
                                    }.foregroundColor(.black)
            
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }.environmentObject(UserState())
    }
}
