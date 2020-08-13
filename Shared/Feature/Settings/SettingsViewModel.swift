//
//  SettingsViewModel.swift
//  HypeLove
//
//  Created by Jaume on 13/08/2020.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    
    @Published var userName: String = ""
    private let userState: UserState
    
    init(userState: UserState) {
        self.userState = userState
        userState.$userName.assign(to: &$userName)
    }
    
    func deleteData() {
        NetworkClient.shared.token = nil
        KeychainService.deleteData(userName: userName)
        userState.userName = ""
    }
}
