//
//  TrackCarrouselView.swift
//  HypeLove
//
//  Created by Jaume on 11/08/2020.
//

import SwiftUI

struct TrackCarrouselView: View {
    
    @Environment(\.redactionReasons) var redactionReasons
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(0..<11) { index in
                    VStack {
                        ZStack(alignment: .bottom) {
                            
                            //Album image
                            Image("sample\(index)")
                                .resizable()
                                .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width / 2)
                                .cornerRadius(5)
                            
                            //Likes
                            HStack {
                                Text("\(index * index)")
                                Image(systemName: "heart.fill")
                                    .unredacted()
                            }
                            .foregroundColor(.white)
                            .font(Font.largeTitle.weight(.heavy))
                            .shadow(color: .black, radius: redactionReasons.isEmpty ? 2 : 0)
                            .padding()
                        }
                        
                        //Title + artist
                        HStack {
                            VStack(alignment: .leading) {
                                Text(TrackDetails.placeholderTracks[index].title)
                                    .fontWeight(.bold)
                                Text(TrackDetails.placeholderTracks[index].artist)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                            }
                            Spacer(minLength: 0)
                        }
                        .frame(width: UIScreen.main.bounds.width / 2)
                        
                        Spacer()
                    }
                    .padding([.leading, .trailing], 15)
                    .modifier(MakeButton {
                        print("hola")
                    })
                }
            }
        }
    }
}

struct TrackCarrouselView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TrackCarrouselView()
            TrackCarrouselView()
                .redacted(reason: .placeholder)
        }
    }
}
