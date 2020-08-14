//
//  TracksDataStore.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import Foundation
import Combine

final class TracksDataStore: ObservableObject {
    
    lazy var popular =   TracksDownloader<TrackListRequest>(endPoint: .popular(.now))
    lazy var lastWeek =  TracksDownloader<TrackListRequest>(endPoint: .popular(.lastWeek))
    lazy var noRemix =   TracksDownloader<TrackListRequest>(endPoint: .popular(.noRemix))
    lazy var remix =     TracksDownloader<TrackListRequest>(endPoint: .popular(.remix))
    lazy var favorites = TracksDownloader<TrackListRequest>(endPoint: .favorites)
    lazy var history =   TracksDownloader<TrackListRequest>(endPoint: .history)
    lazy var feed =      TracksDownloader<TrackListRequest>(endPoint: .feed)
    
    @Published var popularMode = PopularMode.now
    
    func store(for mode: PopularMode) -> TracksDownloader<TrackListRequest> {
        switch mode {
        case .now: return popular
        case .lastWeek: return lastWeek
        case .noRemix: return noRemix
        case .remix: return remix
        }
    }
}
