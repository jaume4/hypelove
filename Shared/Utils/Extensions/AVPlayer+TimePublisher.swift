//
//  AVPlayer+TimePublisher.swift
//  HypeLove
//
//  Created by Jaume on 21/08/2020.
//

import Foundation
import Combine
import AVKit

extension AVPlayer {
    
    private struct TimePublisher: Publisher {
        
        typealias Output = Double
        typealias Failure = Never
        
        let player: AVPlayer
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = TimeSuscriber<S>()
            subscription.target = subscriber
            
            subscriber.receive(subscription: subscription)
            
            let timeObserver = player.addPeriodicTimeObserver(forInterval:  CMTime(seconds: 1, preferredTimescale: 1), queue: nil) { time in
                guard !time.seconds.isNaN else { return }
                subscription.receive(value: time.seconds)
            }
            
            subscription.removeToken = { [weak player] in player?.removeTimeObserver(timeObserver as Any) }
        }  
    }
    
    private class TimeSuscriber<Target: Subscriber>: Subscription where Target.Input == Double {
        
        var target: Target?
        var removeToken: (() -> ())?
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            removeToken?()
            removeToken = nil
        }
        
        func receive(value: Double) {
            _ = target?.receive(value)
        }
    }
    
    func timePublisher() -> AnyPublisher<Double, Never> {
        return TimePublisher(player: self)
            .eraseToAnyPublisher()
    }
}
