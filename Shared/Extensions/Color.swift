//
//  Colors.swift
//  HypeLove
//
//  Created by Jaume on 07/08/2020.
//

import Foundation
import SwiftUI

extension Color {
    static let background = Color(red: 0.506, green: 0.914, blue: 0.475, opacity: 1.000)
    static let contrast = Color(red: 0.729, green: 0.231, blue: 0.275, opacity: 1.000)
    static let buttonFill = Color(red: 0.984, green: 0.212, blue: 0.251, opacity: 1.000)
    static let buttonDisabled = Color(red: 0.784, green: 0.016, blue: 0.055, opacity: 1.000)
    static let fillDark = Color(red: 0.667, green: 0.561, blue: 0.400, opacity: 1.000)
    static let fillClear = Color(red: 0.961, green: 0.961, blue: 0.961, opacity: 1.000)
    
    init?(hex: String) {
        guard hex.count == 6 else { return nil }
        let low = hex.lowercased()
        let lowCharacterSet = CharacterSet(charactersIn: low)
        guard lowCharacterSet.isSubset(of: String.hexCharacterSet) else { return nil }
        let endIndex = hex.endIndex
        let uintSequence = sequence(state: hex.startIndex) { index -> UInt8? in
            guard index < endIndex else { return nil }
            let chunkEndIndex = hex.index(index, offsetBy: 2, limitedBy: endIndex) ?? endIndex
            defer { index = chunkEndIndex }
            return UInt8(hex[index..<chunkEndIndex], radix: 16)

        }
        
        let values: [Double] = [UInt8].init(uintSequence).map{ Double($0) / 255 }
        self.init(red: values[0], green: values[1], blue: values[2])
    }
}

fileprivate extension String {
    static let hexCharacterSet = CharacterSet(charactersIn: "0123456789ABCDEFabcdef")
}
