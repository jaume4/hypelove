//
//  LoginViewModel.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//

import Foundation
import Combine
import SwiftUI

final class LoginViewModel: ObservableObject {
    
    @Published var password: String = ""
    @Published var loginCancellable: AnyCancellable?
    @Published var loginError: (NetworkError<LoginError>)?
    
    let userState: UserState
    
    init(userState: UserState) {
        self.userState = userState
    }
    
    func doLogin() {
        loginError = nil
        let request = LoginRequest(userName: userState.userName, password: password, deviceID: userState.deviceID)

        loginCancellable = NetworkClient.shared.send(request).sink { [weak self] (completion) in
            guard let self = self else { return }
            defer { self.loginCancellable = nil }
            switch completion {
            case .finished: return
            case .failure(let error): self.loginError = error
            }
        } receiveValue: { [weak self] (response) in
            guard let self = self else { return }
            KeychainService.save(userName: self.userState.userName, token: response.hmToken)
            self.userState.set(token: response.hmToken)
        }
    }
}
