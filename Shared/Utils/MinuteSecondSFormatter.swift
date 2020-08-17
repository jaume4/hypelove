//
//  MinuteSecondFormatter.swift
//  HypeLove
//
//  Created by Jaume on 09/08/2020.
//

import Foundation

struct MinuteSecondsFormatter {
    private init() {}
    
    static let formatter: DateComponentsFormatter = {
       let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        formatter.unitsStyle = .positional
        return formatter
    }()
    
    static func format(_ time: Double) -> String {
        return formatter.string(from: time) ?? "Unknown"
    }
}
