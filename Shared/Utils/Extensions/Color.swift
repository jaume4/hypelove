//
//  Colors.swift
//  HypeLove
//
//  Created by Jaume on 07/08/2020.
//

import Foundation
import SwiftUI

enum APPColor: String {
    case fill
}

extension Color {
    static let background = Color(red: 0.506, green: 0.914, blue: 0.475, opacity: 1.000)
    static let buttonMain = Color(red: 0.929, green: 0.106, blue: 0.180, opacity: 1.000)
    static let buttonDisabled = Color(red: 0.443, green: 0.035, blue: 0.071, opacity: 1.000)
    
    init(_ appColor: APPColor) {
        self = Color(appColor.rawValue)
    }
    
    init?(hex: String) {
        guard hex.count == 6 else { return nil }
        let low = hex.lowercased()
        let lowCharacterSet = CharacterSet(charactersIn: low)
        guard lowCharacterSet.isSubset(of: String.hexCharacterSet) else { return nil }
        
        let values: [Double] = hex.chuncked(size: 2)
            .compactMap { UInt8($0, radix: 16) }
            .map{ Double($0) / 255 }
        
        self.init(red: values[0], green: values[1], blue: values[2])
    }
    
    static var random: Color {
        Color(hue: Double.random(in: 0...1), saturation: Double.random(in: 0.5...1), brightness: 1)
    }
}

fileprivate extension String {
    static let hexCharacterSet = CharacterSet(charactersIn: "0123456789ABCDEFabcdef")
}

struct Color_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Color.background
            Color.buttonMain
            Color.buttonDisabled
            Color(.fill)
        }
        
        VStack {
            Color.background
            Color.buttonMain
            Color.buttonDisabled
            Color(.fill)
        }
        .preferredColorScheme(.dark)
    }
}
