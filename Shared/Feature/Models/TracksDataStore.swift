//
//  TracksDataStore.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import Foundation
import Combine

final class TracksDataStore: ObservableObject {
    
    lazy var popular = TracksDownloader(trackListMode: nil)
    lazy var lastWeek = TracksDownloader(trackListMode: .lastweek)
    lazy var fresh = TracksDownloader(trackListMode: .fresh)
    lazy var noRemix = TracksDownloader(trackListMode: .noremix)
    lazy var remix = TracksDownloader(trackListMode: .remix)
    
    func store(for mode: TrackListMode?) -> TracksDownloader {
        switch mode {
        case nil: return popular
        case .lastweek: return lastWeek
        case .fresh: return fresh
        case .noremix: return noRemix
        case .remix: return remix
        }
    }
}
