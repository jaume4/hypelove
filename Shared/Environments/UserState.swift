//
//  UserState.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//

import Foundation

class UserState: ObservableObject {
    @Published var userName: String = ""
    @Published var validToken = false
    
    init() {
        if let userData = KeychainService.getUserData() {
            userName = userData.userName
//            set(token: userData.token)
        }
    }
    
    func set(token: String) {
        NetworkClient.shared.token = token
        validToken = true
    }
}
