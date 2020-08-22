//
//  PopularMode.swift
//  HypeLove
//
//  Created by Jaume on 14/08/2020.
//

import Foundation

enum PopularMode: String, Hashable {
    case now = ""
    case lastWeek = "lastweek"
    case noRemix = "noremix"
    case remix
    
    var title: String {
        switch self {
        case .now: return "Popular now"
        case .lastWeek: return "Popular last week"
        case .noRemix: return "No remix"
        case .remix: return "Remix"
        }
    }
}
