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
    @Published var selectedTab = HomeTab.popular
    
    private var loginTokenCancellable: AnyCancellable?
    private var userNameCancellable: AnyCancellable?
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        
        userName = savedUserName
        
        loginTokenCancellable = NetworkClient.shared.$token
            .receive(on: RunLoop.main)
            .sink { [weak self] (token) in
                self?.validToken = token != nil
            }
        
        if let savedToken = KeychainService.getSavedToken(userName: savedUserName) {
            validToken = true
            set(token: savedToken)
        }
        
        userNameCancellable = $userName
            .receive(on: RunLoop.main)
            .sink { [weak self] in
            self?.savedUserName = $0
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
    
    func set(token: String) {
        NetworkClient.shared.token = token
    }
}
