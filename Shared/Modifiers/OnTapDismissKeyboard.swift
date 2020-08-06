//
//  OnTapDismissKeyboard.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//

import Foundation
import SwiftUI

struct OnTapDismissKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .compactMap({$0 as? UIWindowScene}).first?
                    .windows.first(where: {$0.isKeyWindow})
                keyWindow?.endEditing(true)
        }
    }
}
