//
//  HypeButton.swift
//  HypeLove
//
//  Created by Jaume on 09/08/2020.
//

import Foundation
import SwiftUI

struct HypeButton: ButtonStyle {
    var enabled: Bool = true
    var loading = false
    
    func fillColor(isPressed: Bool, enabled: Bool) -> Color {
        switch (isPressed, enabled) {
        case (_, false): return Color.buttonDisabled
        case (true, true): return Color.buttonMain.opacity(0.7)
        case (false, true): return Color.buttonMain
        }
    }
    
    @ViewBuilder
    func backgroundView(configuration: ButtonStyleConfiguration) -> some View {
        if loading {
            AnimatableGradient(startColor: .buttonMain, endColor: .buttonDisabled)
                .cornerRadius(10)
        }
        else {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(fillColor(isPressed: configuration.isPressed, enabled: enabled))
        }
    }
    
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration.label
            .font(Font.body.bold())
            .frame(maxWidth: .infinity)
            .foregroundColor(Color.white.opacity(configuration.isPressed ? 0.7 : 1.0))
            .padding(8)
            .background(backgroundView(configuration: configuration))
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
            .padding([.leading, .trailing], expand ? 16 : 0)
            .padding([.top, .bottom], 8)
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
            Button("Primary", action: {})
                .buttonStyle(HypeButton(loading: true))
        }
        .padding()
        
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
            Button("Primary", action: {})
                .buttonStyle(HypeButton(loading: true))
        }
        .padding()
        .preferredColorScheme(.dark)
        
    }
}
