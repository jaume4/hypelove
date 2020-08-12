//
//  HypeButton.swift
//  HypeLove
//
//  Created by Jaume on 09/08/2020.
//

import Foundation
import SwiftUI

var foreverAnimation: Animation {
    Animation.linear(duration: 2.0)
        .repeatForever(autoreverses: false)
}

struct HypeButton: ButtonStyle {
    var enabled: Bool = true
    
    func fillColor(isPressed: Bool, enabled: Bool) -> Color {
        switch (isPressed, enabled) {
        case (_, false): return Color.buttonDisabled
        case (true, true): return Color.buttonMain.opacity(0.7)
        case (false, true): return Color.buttonMain
        }
    }
    
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration.label
            .font(Font.body.bold())
            .frame(maxWidth: .infinity)
            .foregroundColor(Color(.fill).opacity(configuration.isPressed ? 0.7 : 1.0))
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(fillColor(isPressed: configuration.isPressed, enabled: enabled))
        )
    }
}

struct HypeSecondaryButton: ButtonStyle {
    var enabled: Bool = true
    var expand: Bool = true
    
    func fillColor(isPressed: Bool, enabled: Bool) -> Color {
        switch (isPressed, enabled) {
        case (_, false): return Color.buttonDisabled
        case (true, true): return Color.buttonMain.opacity(0.7)
        case (false, true): return Color.buttonMain
        }
    }
    
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration.label
            .frame(maxWidth: expand ? .infinity : nil)
            .font(Font.body.bold())
            .foregroundColor(fillColor(isPressed: configuration.isPressed, enabled: enabled))
            .padding(8)
    }
}


struct HypeButtons_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Primary", action: {})
                .buttonStyle(HypeButton())
            Button("Secondary", action: {})
                .buttonStyle((HypeSecondaryButton()))
            Spacer().frame(height: 30)
            Button("Primary dis", action: {})
                .buttonStyle(HypeButton(enabled: false))
            Button("Secondary dis", action: {})
                .buttonStyle((HypeSecondaryButton(enabled: false)))
        }.padding()
    }
}
