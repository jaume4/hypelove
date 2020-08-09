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
    }
}

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    @EnvironmentObject var userState: UserState
    @Namespace var loginNameSpace
    let loginButtonID = "loginButton"
    var loginDisabled: Bool {
        viewModel.loginCancellable != nil || viewModel.password.isEmpty || userState.userName.isEmpty
    }
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
                .modifier(OnTapDismissKeyboard())
            VStack(spacing: 20) {
                TextField("Username", text: $userState.userName)
                    .textContentType(.username)
                    .autocapitalization(.none)
                    .modifier(HypeTextfield())
                SecureField("Password", text: $viewModel.password)
                    .textContentType(.password)
                    .modifier(HypeTextfield())
                Button("Login", action: viewModel.doLogin)
                .disabled(loginDisabled)
                .buttonStyle(HypeButton(enabled: !loginDisabled))
                    
                Button("Not now", action: {print("skip")})
                    .buttonStyle(HypeSecondaryButton())
            }
            .padding()
            .matchedGeometryEffect(id: loginButtonID, in: loginNameSpace, properties: [.position], anchor: .bottom)
            LoginViewError(error: viewModel.loginError)
                .matchedGeometryEffect(id: loginButtonID, in: loginNameSpace, properties: [.position], anchor: .top, isSource: false)
            
        }.navigationTitle("Welcome")
    }
}

struct LoginView_Previews: PreviewProvider {
    static let userState = UserState()
    static let viewModel = LoginViewModel(userState: userState)
    
    static var previews: some View {
        NavigationView {
            LoginView(viewModel: viewModel)
                .environmentObject(userState)
                .onAppear {
                    viewModel.loginError = NetworkError<LoginError>.custom(.wrongUsername)
                }
        }
    }
}
