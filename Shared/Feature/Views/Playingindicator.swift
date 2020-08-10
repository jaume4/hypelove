//
//  Playing indicator.swift
//  HypeLove
//
//  Created by Jaume on 09/08/2020.
//

import SwiftUI
import Combine

final class Animator: ObservableObject {
    @Published var percent: CGFloat = 0.4
    
    init() {
        
        Timer.publish(every: 1 / 4, on: RunLoop.main, in: .default)
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
            
            HStack(spacing: proxy.size.width / 15) {
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    Rectangle()
                        .frame(height: proxy.size.height * animator.percent)
                        .cornerRadius(6)
                        .animation(.easeIn)
                    Spacer(minLength: 0)
                }
                Rectangle()
                    .frame(height: proxy.size.height * (0.3 + (0.7 * (1 - CGFloat.random(in: 0...animator.percent)))))
                    .cornerRadius(6)
                    .animation(.easeIn)
                Rectangle()
                    .frame(height: proxy.size.height * (0.3 + (0.7 * (1 - CGFloat.random(in: 0...animator.percent)))))
                    .cornerRadius(6)
                    .animation(.easeIn)
                Rectangle()
                    .frame(height: proxy.size.height * (0.6 + (0.4 * (1 - CGFloat.random(in: 0...animator.percent)))))
                    .cornerRadius(6)
                    .animation(.easeIn)
                Rectangle()
                    .frame(height: proxy.size.height * (0.3 + (0.7 * (1 - CGFloat.random(in: 0...animator.percent)))))
                    .cornerRadius(6)
                    .animation(.easeIn)
            }
        }
    }
}

struct PlayingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        PlayingIndicator()
    }
}
