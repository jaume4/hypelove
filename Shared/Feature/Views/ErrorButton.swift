//
//  ErrorButton.swift
//  HypeLove
//
//  Created by Jaume on 11/08/2020.
//

import SwiftUI

struct ErrorButton<T: RawRepresentable>: View where T.RawValue == String {
    
    let error: NetworkError<T>
    let actionDescription: String
    let action: () -> ()
    @Environment(\.parentGeometry) var geometry: GeometryProxy?
    
    var label: String {
        var errorDescription: String
        switch error {
        case .custom(let error): errorDescription =  "\(error.rawValue)"
        case .noConnection: errorDescription =  "No connection"
        default: errorDescription = "Something went wrong"
        }
        return errorDescription + actionDescription
    }
    
    init? (error: NetworkError<T>?, actionDescription: String, action: @escaping () -> ()) {
        guard let error = error else { return nil }
        self.error = error
        self.action = action
        self.actionDescription = actionDescription
    }
    
    var body: some View {
        Button(label, action: action)
            .buttonStyle(HypeSecondaryButton())
            .padding()
            .frame(height: geometry?.size.height)
            .unredacted()
    }
    
}
