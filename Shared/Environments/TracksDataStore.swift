//
//  TracksDataStore.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import Foundation
import Combine

final class TracksDataStore: ObservableObject {
    
    lazy var popular = TracksDownloader(trackListMode: .now)
    lazy var lastWeek = TracksDownloader(trackListMode: .lastWeek)
    lazy var noRemix = TracksDownloader(trackListMode: .noRemix)
    lazy var remix = TracksDownloader(trackListMode: .remix)
    
    func store(for mode: PopularMode) -> TracksDownloader {
        switch mode {
        case .now: return popular
        case .lastWeek: return lastWeek
        case .noRemix: return noRemix
        case .remix: return remix
        }
    }
}
