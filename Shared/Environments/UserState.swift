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
    @AppStorage("userName") var userName: String = ""
    @Published var validToken = false
    
    private var loginTokenCancellable: AnyCancellable?
    
    init() {
        loginTokenCancellable = NetworkClient.shared.$token
            .receive(on: RunLoop.main)
            .sink { [weak self] (token) in
                self?.validToken = token != nil
            }
        
        if let savedToken = KeychainService.getSavedToken(userName: userName) {
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
    
    func set(token: String) {
        NetworkClient.shared.token = token
    }
}
