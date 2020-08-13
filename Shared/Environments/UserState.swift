//
//  UserState.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//

import Foundation
import SwiftUI
import Combine

final class UserState: ObservableObject {
    @AppStorage("deviceID") private(set) var deviceID: String = ""
    @AppStorage("userName") private var savedUserName: String = ""
    @Published var validToken = false
    @Published var userName: String = ""
    @Published var selectedTab = HomeTab.home
    @Published var popularMode = PopularMode.now
    @Published var presentingSettings = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        
        setupCancellables()
        
        if !savedUserName.isEmpty, let savedToken = KeychainService.getSavedToken(userName: savedUserName) {
            validToken = true
            set(token: savedToken)
        }
        
        if deviceID.isEmpty {
            let chars = "0123456789abcdef"
            var randomID = ""
            for _ in 0..<32 {
                let char = chars.randomElement()
                randomID.append(char!)
            }
            deviceID = randomID
        }
    }
    
    private func setupCancellables() {
        NetworkClient.shared.$token
            .map { $0 != nil }
            .receive(on: DispatchQueue.main)
            .assign(to: &$validToken)
        
        userName = savedUserName
        
        $userName
            .receive(on: DispatchQueue.main)
            .assign(to: \.savedUserName, on: self)
            .store(in: &cancellables)
    }
    
    func set(token: String) {
        NetworkClient.shared.token = token
    }
}
