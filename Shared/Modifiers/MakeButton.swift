//
//  MakeButton.swift
//  HypeLove
//
//  Created by Jaume on 10/08/2020.
//

import SwiftUI

struct MakeButton: ViewModifier {
    let action: () -> ()
    
    func body(content: Content) -> some View {
        Button(action: action, label: {content})
            .foregroundColor(.primary)
    }
}
