//
//  BigNumberFormatter.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import Foundation

enum BigNumberFormatter {
    
    static func format(_ number: Int) -> String {
        
        switch number {
        case 0..<1_000:
            return "\(number)"
        case 1_000..<1_000_000:
            var number = number
            if number % 1_000 >= 500 {
                number += 1_000
            }
            return "\(number / 1_000)K"
        case 1_000_000..<1_000_000_000:
            var number = number
            if number % 1_000_000 >= 500_000 {
                number += 1_000_000
            }
            return "\(number / 1_000_000)M"
        case 100_000_000..<1_000_000_000:
            var number = number
            if number % 1_000_000_000 >= 500_000_000 {
                number += 1_000_000_000
            }
            return "\(number / 1_000_000_000)B"
        default:
            return "\(number)"
        }
    }
}
