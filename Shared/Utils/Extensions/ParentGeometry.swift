//
//  ParentGeometry.swift
//  HypeLove
//
//  Created by Jaume on 14/08/2020.
//

import Foundation
import SwiftUI

fileprivate struct ParentGeometry: EnvironmentKey {
    static let defaultValue: GeometryProxy? = nil
}

extension EnvironmentValues {
    var parentGeometry: GeometryProxy? {
        get { self[ParentGeometry.self] }
        set { self[ParentGeometry.self] = newValue }
    }
}

extension View {
    func parentGeometry(_ geometry: GeometryProxy?) -> some View {
        environment(\.parentGeometry, geometry)
    }
}
