//
//  View+if.swift
//  HypeLove
//
//  Created by Jaume on 23/08/2020.
//

import Foundation
import SwiftUI


//https://gist.github.com/larsaugustin/a61873eec70ac35367c54d5ee5dd3d61
extension View {
    @ViewBuilder
    public func `if`<V>(_ condition: Bool, input: (Self) -> V) -> some View where V: View {
        if condition {
            input(self)
        } else {
            self
        }
    }
}
