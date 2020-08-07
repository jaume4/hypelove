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
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
