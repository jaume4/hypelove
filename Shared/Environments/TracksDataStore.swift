//
//  TracksDataStore.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import Foundation
import Combine

final class TracksDataStore: ObservableObject {
    
    lazy var popular = TracksDownloader<PopularListRequest>(requestMaker: { page in return PopularListRequest(page: page, mode: .now)})
    lazy var lastWeek = TracksDownloader<PopularListRequest>(requestMaker: { page in return PopularListRequest(page: page, mode: .lastWeek)})
    lazy var noRemix = TracksDownloader<PopularListRequest>(requestMaker: { page in return PopularListRequest(page: page, mode: .noRemix)})
    lazy var remix = TracksDownloader<PopularListRequest>(requestMaker: { page in return PopularListRequest(page: page, mode: .remix)})
    
    lazy var favorites = TracksDownloader<FavoritesListRequest>(requestMaker: { page in return FavoritesListRequest(page: page)})
    
    @Published var popularMode = PopularMode.now
    
    func store(for mode: PopularMode) -> TracksDownloader<PopularListRequest> {
        switch mode {
        case .now: return popular
        case .lastWeek: return lastWeek
        case .noRemix: return noRemix
        case .remix: return remix
        }
    }
}
