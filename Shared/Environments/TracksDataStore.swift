//
//  TracksDataStore.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import Foundation
import Combine

final class TracksDataStore: ObservableObject {
    
    lazy var popular = TracksDownloader(popularListMode: .now)
    lazy var lastWeek = TracksDownloader(popularListMode: .lastWeek)
    lazy var noRemix = TracksDownloader(popularListMode: .noRemix)
    lazy var remix = TracksDownloader(popularListMode: .remix)
    
    var popularMode = PopularMode.now
    
    func store(for mode: PopularMode) -> TracksDownloader {
        switch mode {
        case .now: return popular
        case .lastWeek: return lastWeek
        case .noRemix: return noRemix
        case .remix: return remix
        }
    }
}
