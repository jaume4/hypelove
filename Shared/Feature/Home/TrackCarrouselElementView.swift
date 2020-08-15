//
//  TrackCarrouselElementView.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import SwiftUI
import Combine

struct TrackCarrouselElementView: View {
    
    @State var track: TrackDetails?
    @StateObject var imageDownloader = ImageDownloader()
    @EnvironmentObject var playingState: PlayingState
    @Environment(\.redactionReasons) var redactionReasons
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                
                //Album image
                (imageDownloader.image ?? Image(decorative: "placeholder"))
                    .resizable()
                    .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width / 2)
                    .cornerRadius(10)
                    .redacted(reason: imageDownloader.image == nil ? .placeholder : [])
                
                //Likes
                HStack {
                    Text(BigNumberFormatter.format(track?.lovedCount ?? Int.random(in: 10...1000)))
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
                    Text(track?.title ?? String(repeating: "w", count: Int.random(in: 15...25)))
                        .fontWeight(.bold)
                    Text(track?.artist ?? String(repeating: "w", count: Int.random(in: 5...10)))
                        .fontWeight(.bold)
                        .foregroundColor(Color(.secondaryLabel))
                }
                Spacer(minLength: 0)
            }
            .frame(width: UIScreen.main.bounds.width / 2)
            
            Spacer(minLength: 0)
        }
        .padding([.leading, .trailing], 15)
        .modifier(MakeButton {
            playingState.play(track: track)
        })
        .onAppear {
            if redactionReasons.isEmpty, let url = track?.imageURL {
                imageDownloader.download(url)
            }
        }
        .onChange(of: track) { value in
            if redactionReasons.isEmpty, imageDownloader.image == nil, let url = value?.imageURL {
                imageDownloader.download(url)
            }
        }
    }
}

struct TrackCarrouselElementView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            TrackCarrouselElementView(track: TrackDetails.placeholderTracks.first!)
            TrackCarrouselElementView()
                .redacted(reason: .placeholder)
        }
        .padding()
        .environmentObject(PlayingState())
        .previewLayout(.fixed(width: 700, height: 300))
    }
}
