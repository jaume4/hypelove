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
        .font(Font.callout.bold())
    }
}

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    @EnvironmentObject var userState: UserState
    @Environment(\.presentationMode) var presentationMode
    @Namespace var loginNameSpace
    let loginButtonID = "loginButton"
    var loginDisabled: Bool {
        viewModel.loginCancellable != nil || viewModel.password.isEmpty || userState.userName.isEmpty
    }
    
    var body: some View {
        ZStack {
            Color.clear.edgesIgnoringSafeArea(.all)
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
            }
            .padding()
            .matchedGeometryEffect(id: loginButtonID, in: loginNameSpace, properties: [.position], anchor: .bottom)
            LoginViewError(error: viewModel.loginError)
                .matchedGeometryEffect(id: loginButtonID, in: loginNameSpace, properties: [.position], anchor: .top, isSource: false)
            
        }
        .onChange(of: userState.validToken, perform: { loggedIn in
            if loggedIn {
                presentationMode.wrappedValue.dismiss()
            }
        })
        .navigationTitle("Welcome")
        .navigationBarItems(trailing:
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Image(systemName: "xmark")
                                })
                                .accentColor(.buttonMain)
        )
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
        .accentColor(.buttonMain)
        
        NavigationView {
            LoginView(viewModel: viewModel)
                .environmentObject(userState)
                .onAppear {
                    viewModel.loginError = NetworkError<LoginError>.custom(.wrongUsername)
                }
        }
        .accentColor(.buttonMain)
        .preferredColorScheme(.dark)
    }
}
