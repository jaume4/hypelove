//
//  HypeTexfield.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//

import Foundation
import SwiftUI

struct HypeTextfield: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke()
            )
            .font(Font.body.bold())
    }
}

struct HypeTexfield_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextField.init("", text: .constant("Textfield"))
                .modifier(HypeTextfield())
                .padding()
            TextField.init("", text: .constant("Textfield"))
                .modifier(HypeTextfield())
                .padding()
                .environment(\.colorScheme, .dark)
                .background(Color.black)
        }
    }
}
