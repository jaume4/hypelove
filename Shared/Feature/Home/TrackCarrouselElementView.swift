//
//  TrackCarrouselElementView.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import SwiftUI
import Combine

struct TrackCarrouselElementView: View {
    
    @State var track: TrackDetails
    @ObservedObject var imageDownloader: ImageDownloader
    @EnvironmentObject var player: Player
    @Environment(\.redactionReasons) var redactionReasons
    let width =  UIScreen.main.bounds.width / 2
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                
                //Album image
                (imageDownloader.image ?? Image(decorative: "placeholder"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: width)
                    
                    .cornerRadius(10)
                    .redacted(reason: imageDownloader.image == nil ? .placeholder : [])
                
                //Likes
                HStack {
                    Text(BigNumberFormatter.format(track.lovedCount))
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
                    Text(track.title)
                        .fontWeight(.bold)
                    Text(track.artist)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.secondaryLabel))
                }
                Spacer(minLength: 0)
            }
            .frame(width: width)
            
            Spacer(minLength: 0)
        }
        .padding([.leading, .trailing], 15)
        
    }
}

struct TrackCarrouselElementView_Previews: PreviewProvider {
    
    static let track = TrackDetails.placeholderTracks.first!
    
    static var previews: some View {
        HStack {
            TrackCarrouselElementView(track: track, imageDownloader: ImageDownloader(track.imageURL, placeholder: false))
            TrackCarrouselElementView(track: track, imageDownloader: ImageDownloader(track.imageURL, placeholder: false))
                .redacted(reason: .placeholder)
        }
        .padding()
        .environmentObject(Player())
        .previewLayout(.fixed(width: 700, height: 300))
    }
}
