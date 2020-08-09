//
//  TrackView.swift
//  HypeLove
//
//  Created by Jaume on 08/08/2020.
//

import SwiftUI

struct TrackView: View {
    
    @State var track: TrackDetails
    @State var isPlaying: Bool = false
    
    var body: some View {
        HStack {
            Spacer(minLength: 5)
            ZStack {
                Button(action: {
                    print("play \(track)")
                }, label: {
                    track.color
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 1)
                })
                if isPlaying {
                    Image(systemName: "play.fill")
                        .resizable()
                        .padding()
                        .foregroundColor(.white)
                        .opacity(0.7)
                }
            }.aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
            .frame(maxHeight: 50)
            .padding(5)
            
            VStack(alignment: .leading) {
                Text(track.title)
                    .fontWeight(.bold)
                    .lineLimit(1)
        
                Text(track.artist)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct TrackView_Previews: PreviewProvider {
    
    static let trackDetail = TrackDetails(color: Color.red, title: "Let You Know (feat. London Grammar)", artist: "Flume", duration: "3:27")
    
    static var previews: some View {
        TrackView(track: trackDetail, isPlaying: false)
            .previewLayout(PreviewLayout.fixed(width: 400, height: 400))
    }
}
