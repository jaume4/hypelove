//
//  TracksEndPoint.swift
//  HypeLove
//
//  Created by Jaume on 14/08/2020.
//

import Foundation

enum TracksMode {
    
    case favorites, history, feed
    case popular(PopularMode)
    
    var authNeeded: Bool {
        switch self {
        case .favorites: return true
        case .history: return true
        case .feed: return true
        case .popular: return false
        }
    }
    
    var endPoint: String {
        switch self {
        case .favorites: return "me/favorites"
        case .history: return "me/history"
        case .feed: return "me/feed"
        case .popular: return "popular"
        }
    }
    
    var title: String {
        switch self {
        
        case .favorites: return "Favorites"
        case .history: return "History"
        case .feed: return "Feed"
        case .popular(let popularMode): return popularMode.title
        }
    }
    
    //User to compare track endpoint vs tab
    static func == (lhs: HomeTab, rhs: TracksMode) -> Bool {
        switch (lhs, rhs) {
        case (.favorites, .favorites):
            return true
        case (.history, .history):
            return true
        default: return false
        }
    }
    
}
