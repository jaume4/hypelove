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
    @Namespace var loginNameSpace
    
    var body: some View {
        ZStack {
            Color.green.edgesIgnoringSafeArea(.all)
                .modifier(OnTapDismissKeyboard())
            VStack(spacing: 10) {
                TextField("Username", text: $userState.userName)
                    .textContentType(.username)
                    .autocapitalization(.none)
                    .modifier(HypeTextfield())
                SecureField("Password", text: $viewModel.password)
                    .textContentType(.password)
                    .modifier(HypeTextfield())
                Spacer()
                    .frame(height: 5)
                Button("Login", action: viewModel.doLogin)
                    .disabled(viewModel.loginCancellable != nil || viewModel.password.isEmpty || userState.userName.isEmpty)
                    .matchedGeometryEffect(id: "loginButton", in: loginNameSpace, properties: [.position], anchor: .bottom)
            }
            .padding()
            LoginViewError(error: viewModel.loginError)
                .offset(x: 0, y: 20)
                .matchedGeometryEffect(id: "loginButton", in: loginNameSpace, properties: [.position], anchor: .top, isSource: false)
                
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static let userState = UserState()
    static let viewModel = LoginViewModel(userState: userState)
    
    static var previews: some View {
        LoginView(viewModel: viewModel)
            .environmentObject(userState)
            .onAppear {
                viewModel.loginError = NetworkError<LoginError>.custom(.wrongPassword)
            }
    }
}
