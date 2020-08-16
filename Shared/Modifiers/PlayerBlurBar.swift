//
//  PlayerBlurBar.swift
//  HypeLove
//
//  Created by Jaume on 14/08/2020.
//

import Foundation
import SwiftUI

struct PlayerBlurBar: ViewModifier {
    @EnvironmentObject var player: Player
    let playerPosition: Namespace.ID
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            VisualEffectBlur(blurStyle: .systemThickMaterial)
                .edgesIgnoringSafeArea(.bottom)
                .clipShape(RoundedRectangleCustomCorners(cornerRadius: player.currentTrack == nil ? 0 : 20, roundedCorners: [.topLeft, .topRight]))
                .matchedGeometryEffect(id: player.currentTrack == nil ? PlayerStatus.hidden : PlayerStatus.shown, in: playerPosition, properties: .position, anchor: .top, isSource: false)
                .animation(.easeInOut(duration: 0.2), value: player.currentTrack)
        }
    }
}

