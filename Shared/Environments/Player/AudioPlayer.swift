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

enum PlayerInterruption {
    case began, ended(Bool), failed(Error)
}

final class Player: ObservableObject {
    
    private let player = AVQueuePlayer()
    private let commandCenter = MPRemoteCommandCenter.shared()
    private var tracksMetadata: [URL: StaticMetadata] = [:]
    private var tracks: [URL: TrackDetails] = [:]
    private var playerItems: [AVPlayerItem] = []
    private var isInterrupted: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var currentTrack: TrackDetails?
    @Published var state = PlayerState.paused {
        didSet {
            print("changed state to \(state)")
        }
    }
    
    //MARK: - Initialize & setup
    
    init() {
        registerCancellables()
        registerDefaultCommands()
    }
    
    func play(tracks: [TrackDetails], startIndex: Int?) {
        
        var tracks = tracks
        if let startIndex = startIndex {
            tracks = tracks.suffix(tracks.count - startIndex)
        }
        
        currentTrack = tracks.first
        playerItems.removeAll(keepingCapacity: true)
        playerItems = tracks.map(generateItem(track:))
        setupPlayer()
        handlePlayerItemChange()
        play()
    }
    
    private func generateItem(track: TrackDetails) -> AVPlayerItem {
        
        let asset = AVURLAsset(url: track.url)
        tracksMetadata[track.url] = StaticMetadata(assetURL: track.url, title: track.title, artist: track.artist, artwork: nil)
        tracks[track.url] = track
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
    }
    
    func registerCancellables() {
        
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
            .sink{ [unowned self] _ in
                self.handlePlaybackChange()
            }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] notification in
                self.handleAudioSessionInterruption(notification: notification)
            }.store(in: &cancellables)
        
    }
    
    //MARK: - Playback handling, exposed
    
    func play() {
        
        switch state {
            
        case .stopped:
            state = .playing
            player.play()
            
            handlePlayerItemChange()

        case .playing:
            break
            
        case .paused where isInterrupted:
            state = .playing
            
        case .paused:
            state = .playing
            player.play()
        }
    }
    
    func playPause() {
        if state != .playing {
            play()
        } else {
            pause()
        }
    }
    
    func pause() {
        
        switch state {
            
        case .stopped:
            break
            
        case .playing where isInterrupted:
            state = .paused
            
        case .playing:
            state = .paused
            player.pause()
            
        case .paused:
            break
        }
    }
    
    func nextTrack() {
        
        if case .stopped = state { return }
        
        player.advanceToNextItem()
    }
    
    func previousTrack() {
        
        if case .stopped = state { return }
        
        let currentTime = player.currentTime().seconds
        let currentItems = player.items()
        let previousIndex = playerItems.count - currentItems.count - 1
        
        guard currentTime < 3, previousIndex >= 0, previousIndex < playerItems.count else { seek(to: .zero); return }
        
        player.removeAllItems()
        
        for playerItem in playerItems[(previousIndex)...] {
            
            if player.canInsert(playerItem, after: nil) {
                playerItem.seek(to: CMTime.zero, completionHandler: {_ in})
                player.insert(playerItem, after: nil)
            }
        }
        
        if case .playing = state {
            player.play()
        }
    }
    
    func seek(to position: TimeInterval) {
        seek(to: CMTime(seconds: position, preferredTimescale: 1))
    }
    
    //MARK: - Playback handling, private
    
    private func handlePlaybackChange() {
        
        print("playbachchange")
        
        guard state != .stopped else { return }
        
        // Find the current item.
        
        guard let currentItem = player.currentItem else { /*optOut();*/ return }
        guard currentItem.status == .readyToPlay else { return }
        
        let isPlaying = state == .playing
        let metadata = DynamicMetadata(rate: player.rate,
                                       position: Float(currentItem.currentTime().seconds),
                                       duration: Float(currentItem.duration.seconds))
        
        MetadataHandler.setNowPlayingPlaybackInfo(isPlaying: isPlaying, metadata)
    }
    
    private func seek(to time: CMTime) {
        
        if case .stopped = state { return }
        
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero) {
            isFinished in
            if isFinished {
                self.handlePlaybackChange()
            }
        }
    }
    
    private func handlePlayerItemChange() {
        
        print("item change")
        
        guard state != .stopped else { return }
        
        // Find the current item.
        
        guard let item = player.currentItem?.asset as? AVURLAsset,
              let metadata = tracksMetadata[item.url],
              let track = tracks[item.url]
        else {
            currentTrack = nil
            return
        }
        
        print("track: \(track.title)")
        currentTrack = track
//        guard let currentItem = player.currentItem else { /*optOut();*/ return }
        MetadataHandler.setNowPlayingMetadata(metadata)
        
    }
    
    private func likeTrack() {
        
    }
    
    private func unlikeTrack() {
        
    }
    
    //MARK: - Command handler
    
    private func registerDefaultCommands() {
        
        [commandCenter.playCommand, commandCenter.pauseCommand, commandCenter.nextTrackCommand, commandCenter.previousTrackCommand, commandCenter.changePlaybackPositionCommand].forEach {
            $0.isEnabled = true
            $0.addTarget(handler: handleRemoteEvent)
        }
    }
    
    private func handleRemoteEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        
        print(event)
        
        switch event.command {
        
        case commandCenter.togglePlayPauseCommand:
            playPause()
        
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
            print("no match")
            break
        }
        
        return .success
    }
    
    //MARK: - Interruption handler
    
    private func handleAudioSessionInterruption(notification: Notification) {
        
        // Retrieve the interruption type from the notification.
        
        guard let userInfo = notification.userInfo,
            let interruptionTypeUInt = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeUInt) else { return }
        
        // Begin or end an interruption.
        
        switch interruptionType {
            
        case .began:
            
            // When an interruption begins, just invoke the handler.
            
            handleInterrupt(.began)
            
        case .ended:
            
            // When an interruption ends, determine whether playback should resume
            // automatically, and reactivate the audio session if necessary.
            
            do {
                
                try AVAudioSession.sharedInstance().setActive(true)
                
                var shouldResume = false
                
                if let optionsUInt = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt,
                    AVAudioSession.InterruptionOptions(rawValue: optionsUInt).contains(.shouldResume) {
                    shouldResume = true
                }
                
                handleInterrupt(.ended(shouldResume))
            }
            
            // When the audio session cannot be resumed after an interruption,
            // invoke the handler with error information.
                
            catch {
                handleInterrupt(.failed(error))
            }
            
        @unknown default:
            break
        }
    }
    
    private func handleInterrupt(_ interruption: PlayerInterruption) {
        
        switch interruption {
            
        case .began:
            isInterrupted = true
            
        case .ended(let shouldPlay):
            isInterrupted = false
            
            switch state {
                
            case .stopped:
                break
                
            case .playing where shouldPlay:
                player.play()
                
            case .playing:
                state = .paused
                
            case .paused:
                break
            }
            
        case .failed(let error):
            print(error.localizedDescription)
//            optOut()
        }
    }
    
    //MARK: - Static players
    
    #if DEBUG
    static let songPlaying: Player = {
        let state = Player()
        state.state = .playing
        state.currentTrack = TrackDetails.placeholderTracks[1]
        return state
    }()
    
    static let songPaused: Player = {
        let state = Player()
        state.state = .paused
        state.currentTrack = TrackDetails.placeholderTracks[1]
        return state
    }()
    
    static let noSong: Player = {
        let state = Player()
        state.state = .paused
        return state
    }()
    #endif
}
