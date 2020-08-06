//
//  UserState.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//

import Foundation
import SwiftUI

class UserState: ObservableObject {
    @AppStorage("deviceID") private(set) var deviceID: String = ""
    @AppStorage("userName") var userName: String = ""
    @Published var validToken = false
    
    init() {
        if let savedToken = KeychainService.getSavedToken(userName: userName) {
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
        validToken = true
    }
}
