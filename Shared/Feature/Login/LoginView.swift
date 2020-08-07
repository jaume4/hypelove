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
        .foregroundColor(.contrast)
    }
}

struct HypeButton: ButtonStyle {
    var enabled: Bool = true
    
    func fillColor(isPressed: Bool, enabled: Bool) -> Color {
        switch (enabled, isPressed) {
        case (false, _): return Color.buttonDisabled
        case (true, true): return Color.buttonFill.opacity(0.7)
        case (true, false): return Color.buttonFill
        }
    }
    
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .foregroundColor(configuration.isPressed ? Color.fillClear.opacity(0.7) : Color.fillClear)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(fillColor(isPressed: configuration.isPressed, enabled: enabled))
        )
    }
}

struct HypeSecondaryButton: ButtonStyle {
    var enabled: Bool = true
    
    func fillColor(isPressed: Bool, enabled: Bool) -> Color {
        switch (enabled, isPressed) {
        case (false, _): return Color.buttonDisabled
        case (true, true): return Color.buttonFill.opacity(0.7)
        case (true, false): return Color.buttonFill
        }
    }
    
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .foregroundColor(fillColor(isPressed: configuration.isPressed, enabled: enabled))
            .padding(8)
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
                Button(action: viewModel.doLogin) {
                    Text("Login")
                        .fontWeight(.heavy)
                }.disabled(loginDisabled)
                .buttonStyle(HypeButton(enabled: !loginDisabled))
                    
                Button(action: {
                    print("skip")
                }, label: {
                    Text("Skip")
                        .fontWeight(.heavy)
                })
                .buttonStyle(HypeSecondaryButton())
            }
            .padding()
            .matchedGeometryEffect(id: loginButtonID, in: loginNameSpace, properties: [.position], anchor: .bottom)
            LoginViewError(error: viewModel.loginError)
//                .offset(x: 0, y: 15)
                .matchedGeometryEffect(id: loginButtonID, in: loginNameSpace, properties: [.position], anchor: .top, isSource: false)
            
        }
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
