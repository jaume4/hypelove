//
//  FullPlayerView.swift
//  HypeLove
//
//  Created by Jaume on 16/08/2020.
//

import SwiftUI

struct FullPlayerView: View {
    
    @EnvironmentObject var player: Player
    @Namespace var volumeSlider
    @StateObject var imageDownloader = ImageDownloader()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Spacer()
                
                (imageDownloader.image ?? Image("placeholder"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .redacted(reason: imageDownloader.image == nil ? .placeholder : [])
                    .cornerRadius(30)
                    .shadow(radius: 20)
                    .padding()
                    .onChange(of: player.currentTrack) { newTrack in
                        if let url = newTrack?.imageURL {
                            imageDownloader.download(url: url)
                        }
                    }
                    .onAppear {
                        if imageDownloader.image == nil, let url = player.currentTrack?.imageURL {
                            imageDownloader.download(url: url)
                        }
                    }
                
                if let track = player.currentTrack {
                    VStack(alignment: .center) {
                        Text(track.title)
                            .font(Font.title.bold())
                            .fontWeight(.bold)
                        Text(track.artist)
                            .font(Font.title2.bold())
                            .foregroundColor(Color(.secondaryLabel))
                    }
                    .padding()
                }
                
                //Progress
                VStack {
        
                    Slider(value: $player.trackPercent, in: 0...1) { editingBegan in
                        player.userSeeking(begin: editingBegan)
                    }
                    HStack {
                        Text(MinuteSecondsFormatter.format(player.trackPercent * player.trackDuration))
                        Spacer()
                        Text("-" + MinuteSecondsFormatter.format((1.0 - player.trackPercent) * player.trackDuration))
                    }
                    .font(Font.callout.bold())
                }
                .padding()
                .accentColor(.buttonMain)
                
                //Prev, play, next buttons
                HStack {
                    
                    Button(action: {
                        player.likeTrack()
                    }, label: {
                        Image(systemName: true ? "heart.fill" : "heart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 25)
                            .padding([.leading, .trailing], 15)
                    })
                    
                    Button(action: {
                        player.previousTrack()
                    }, label: {
                        Image(systemName: "backward.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 25)
                            .padding([.leading, .trailing], 15)
                    })
                    
                    Button(action: {
                        player.playPause()
                    }, label: {
                        Image(systemName: player.state != .paused ? "pause.fill" : "play.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 35)
                    })
                    
                    Button(action: {
                        player.nextTrack()
                    }, label: {
                        Image(systemName: "forward.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 25)
                            .padding([.leading, .trailing], 15)
                    })
                    
                    Button(action: {
                        print("shuffle")
                    }, label: {
                        Image(systemName: "shuffle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 25)
                            .padding([.leading, .trailing], 15)
                    })
                }
                .accentColor(.primary)
                
                //Volume
                VStack {
                    
                    
                    HStack {
                        Image(systemName: "speaker.fill")
                        VolumeView()
                            .frame(height: 30)
                            .offset(x: 15, y: 6) //MPVolumeView is not aligned, apply offser
                        Image(systemName: "speaker.3.fill")
                    }
                }
                .padding()
                .accentColor(.buttonMain)
                
            }
        }
    }
}

#if DEBUG
struct FullPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        
        FullPlayerView()
            .environmentObject(Player.songPlaying)
        
        FullPlayerView()
            .environmentObject(Player.songPlaying)
            .preferredColorScheme(.dark)
    }
}
#endif
