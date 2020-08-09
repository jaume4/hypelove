//
//  Playing indicator.swift
//  HypeLove
//
//  Created by Jaume on 09/08/2020.
//

import SwiftUI
import Combine

extension String: Error {}

final class Animator: ObservableObject {
    @Published var percent: CGFloat = 0
    
    init() {
        
        Timer.publish(every: 1 / 10, on: .main, in: .default)
            .autoconnect()
            .scan(0) { _, _ in
                return CGFloat.random(in: 0...1)
            }
            .assign(to: &$percent)
    }
}

struct PlayingIndicator: View {
    
    @StateObject var animator = Animator()
    
    var body: some View {
        GeometryReader { proxy in
            
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    Rectangle()
                        .frame(height: proxy.size.height * animator.percent)
                        .animation(.easeIn)
                }
                Spacer(minLength: proxy.size.width / 20)
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    Rectangle()
                        .frame(height: proxy.size.height * (0.4 + (0.6 * (1 - CGFloat.random(in: 0...animator.percent)))))
                        .animation(.easeIn)
                }
                Spacer(minLength: proxy.size.width / 20)
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    Rectangle()
                        .frame(height: proxy.size.height * (0.3 + (0.7 * (1 - CGFloat.random(in: 0...animator.percent)))))
                        .animation(.easeIn)
                }
            }
        }.onDisappear {
            Just(CGFloat(0)).assign(to: &animator.$percent)
        }
    }
}

struct PlayingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        PlayingIndicator()
    }
}
