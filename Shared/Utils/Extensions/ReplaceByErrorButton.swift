//
//  ReplaceByErrorButton.swift
//  HypeLove
//
//  Created by Jaume on 14/08/2020.
//

import Foundation
import SwiftUI

protocol ErrorContainer {
    associatedtype Error: RawRepresentable where Error.RawValue == String
    
    var error: NetworkError<Error>? { get }
    var actionDescription: String { get }
    var action: () -> () { get }
}

struct ReplaceByError<T: RawRepresentable>: ViewModifier where T.RawValue == String {
    
    let active: Bool
    let error: NetworkError<T>?
    let actionDescription: String
    let action: () -> ()
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if active, let error = error {
            ErrorButton(error: error, actionDescription: actionDescription, action: action)
        } else {
            content
        }
    }
}
