//
//  AudioPlayer.swift
//  HypeLove
//
//  Created by Jaume on 15/08/2020.
//

import Foundation
import AVFoundation
import MediaPlayer
import Combine

//https://medium.com/@vdugnist/how-to-cache-avurlasset-data-downloaded-by-avplayer-5400677b8b9e
final class AssetLoader: NSObject, AVAssetResourceLoaderDelegate {
    static let shared = AssetLoader()
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
        print(loadingRequest.contentInformationRequest == nil)
        print(loadingRequest.dataRequest == nil)
        return false
    }
}

enum PlayerState {
    case stopped
    case playing
    case paused
}

final class Player {
    
    private let player = AVQueuePlayer()
    private let commandCenter = MPRemoteCommandCenter.shared()
    private var tracksMetadata: [URL: StaticMetadata] = [:]
    private var playerItems: [AVPlayerItem] = []
    private var cancellables: Set<AnyCancellable> = []
    private var isInterrupted: Bool = false
    
    private(set) var playerState: PlayerState = .stopped {
        didSet {
            #if os(macOS)
            NSLog("%@", "**** Set player state \(playerState), playbackState \(MPNowPlayingInfoCenter.default().playbackState.rawValue)")
            #else
            NSLog("%@", "**** Set player state \(playerState)")
            #endif
        }
    }
    
    init() {
        registerDefaultCommands()
    }
    
    func play(tracks: [TrackDetails]) {
        
        playerItems.removeAll(keepingCapacity: true)
        playerItems = tracks.map(generateItem(track:))
        setupPlayer()
        handlePlayerItemChange()
        play()
    }
    
    private func generateItem(track: TrackDetails) -> AVPlayerItem {
        
        let asset = AVURLAsset(url: track.url)
        tracksMetadata[track.url] = StaticMetadata(assetURL: track.url, title: track.title, artist: track.artist, artwork: nil)
        let item = AVPlayerItem(asset:asset, automaticallyLoadedAssetKeys: ["availableMediaCharacteristicsWithMediaSelectionOptions"])
        return item
    }
    
    private func setupPlayer() {
        
        pause()
        player.removeAllItems()
        
        playerItems.forEach { player.insert($0, after: nil) }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        try! audioSession.setCategory(.playback, mode: .default)
        try! audioSession.setActive(true)
        
        player.publisher(for: \.currentItem)
            .receive(on: DispatchQueue.main)
            .sink{ [unowned self] _ in
                self.handlePlayerItemChange()
            }.store(in: &cancellables)
        
        player.publisher(for: \.rate)
            .receive(on: DispatchQueue.main)
            .sink{ [unowned self] _ in
                self.handlePlaybackChange()
            }.store(in: &cancellables)
        
        player.publisher(for: \.currentItem?.status)
            .receive(on: DispatchQueue.main)
            .sink{ [unowned self]
                _ in self.handlePlaybackChange()
            }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                print("interruption")
            }.store(in: &cancellables)
    }
    

    
    private func handlePlaybackChange() {
        
        guard playerState != .stopped else { return }
        
        // Find the current item.
        
        guard let currentItem = player.currentItem else { /*optOut();*/ return }
        guard currentItem.status == .readyToPlay else { return }
        
        let isPlaying = playerState == .playing
        let metadata = DynamicMetadata(rate: player.rate,
                                       position: Float(currentItem.currentTime().seconds),
                                       duration: Float(currentItem.duration.seconds))
        
        MetadataHandler.setNowPlayingPlaybackInfo(isPlaying: isPlaying, metadata)
    }
    
    func play() {
        
        switch playerState {
            
        case .stopped:
            playerState = .playing
            player.play()
            
            handlePlayerItemChange()

        case .playing:
            break
            
        case .paused where isInterrupted:
            playerState = .playing
            
        case .paused:
            playerState = .playing
            player.play()
        }
    }
    
    func pause() {
        
        switch playerState {
            
        case .stopped:
            break
            
        case .playing where isInterrupted:
            playerState = .paused
            
        case .playing:
            playerState = .paused
            player.pause()
            
        case .paused:
            break
        }
    }
    
    func nextTrack() {
        
        if case .stopped = playerState { return }
        
        player.advanceToNextItem()
    }
    
    func previousTrack() {
        
        if case .stopped = playerState { return }
        
        let currentTime = player.currentTime().seconds
        let currentItems = player.items()
        let previousIndex = playerItems.count - currentItems.count - 1
        
        guard currentTime < 3, previousIndex > 0, previousIndex < playerItems.count else { seek(to: .zero); return }
        
        player.removeAllItems()
        
        for playerItem in playerItems[(previousIndex - 1)...] {
            
            if player.canInsert(playerItem, after: nil) {
                player.insert(playerItem, after: nil)
            }
        }
        
        if case .playing = playerState {
            player.play()
        }
    }
    
    private func seek(to time: CMTime) {
        
        if case .stopped = playerState { return }
        
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero) {
            isFinished in
            if isFinished {
                self.handlePlaybackChange()
            }
        }
    }
    
    private func seek(to position: TimeInterval) {
        seek(to: CMTime(seconds: position, preferredTimescale: 1))
    }
    
    private func handlePlayerItemChange() {
        
        guard playerState != .stopped else { return }
        
        // Find the current item.
        
        guard let item = player.currentItem?.asset as? AVURLAsset,
              let metadata = tracksMetadata[item.url]
              else { return }
//        guard let currentItem = player.currentItem else { /*optOut();*/ return }
        MetadataHandler.setNowPlayingMetadata(metadata)
        
    }
    
    private func likeTrack() {
        
    }
    
    private func unlikeTrack() {
        
    }
    
    //MARK: - Command handler
    
    func registerDefaultCommands() {
        [commandCenter.playCommand, commandCenter.pauseCommand, commandCenter.nextTrackCommand].forEach {
            $0.addTarget(handler: handleRemoteEvent)
        }
    }
    
    func handleRemoteEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        
        switch event {
        
        case commandCenter.pauseCommand:
            pause()
            
        case commandCenter.playCommand:
            play()
            
        case commandCenter.nextTrackCommand:
            nextTrack()
            
        case commandCenter.previousTrackCommand:
            previousTrack()
            
        case commandCenter.changePlaybackPositionCommand:
            guard let event = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            seek(to: event.positionTime)
            
        case commandCenter.likeCommand:
            likeTrack()
            
        case commandCenter.dislikeCommand:
            unlikeTrack()
        
        default:
            break
        }
        
        return .success
    }
    
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        if type == .began {
            print("Interruption began")
            // Interruption began, take appropriate actions
        }
        else if type == .ended {
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // Interruption Ended - playback should resume
                    print("Interruption Ended - playback should resume")
                    play()
                } else {
                    // Interruption Ended - playback should NOT resume
                    print("Interruption Ended - playback should NOT resume")
                }
            }
        }
    }
}
