//
//  LoginView.swift
//  HypeLove
//
//  Created by Jaume on 06/08/2020.
//  Copyright © 2020 Jaume. All rights reserved.
//

import SwiftUI
import Combine

struct LoginViewError: View {
    
    let error: NetworkError<LoginError>?
    
    var body: some View {
        
        VStack {
            switch error {
            case nil: EmptyView()
            case .custom(.wrongPassword):
                Text("Wrong password")
            case .custom(.wrongUsername):
                Text("Wrong username")
            default: EmptyView()
            }
        }
        .font(.callout)
        .foregroundColor(.red)
    }
}

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        ZStack {
            Color.green.edgesIgnoringSafeArea(.all)
            VStack(spacing: 10) {
                TextField("Username", text: $userState.userName)
                    .textContentType(.username)
                    .autocapitalization(.none)
                SecureField("Password", text: $viewModel.password)
                    .textContentType(.password)
                Button("Login", action: viewModel.doLogin)
                .disabled(viewModel.loginCancellable != nil || viewModel.password.isEmpty || userState.userName.isEmpty)
                
                LoginViewError(error: viewModel.loginError)
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(userState: UserState()))
    }
}
