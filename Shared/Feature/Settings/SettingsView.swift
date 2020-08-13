//
//  SettingsView.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @EnvironmentObject var userState: UserState
    @Environment(\.presentationMode) var presentationMode
    @State var presentingLogin = false
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Account")
                    .frame(alignment: .leading)
                    .font(Font.title2.bold())
                Spacer(minLength: 0)
            }
            .padding([.bottom], 16)
            
            if userState.validToken {
                
                HStack {
                    Text(userState.userName)
                        .font(Font.body.bold())
                    Spacer()
                    Button("Log out") {
                        viewModel.deleteData()
                    }
                    .buttonStyle(HypeSecondaryButton(expand: false))
                }
 
            } else {
                Button(action: {presentingLogin.toggle()}, label: {
                    HStack {
                        Text("Log in")
                            
                        Spacer()
                    }
                    
                })
                .buttonStyle(HypeSecondaryButton(expand: false))
            }
            
           Spacer()
        }
        .padding()
        .navigationTitle("Settings")
        .navigationBarItems(trailing:
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Image(systemName: "xmark")
                                })
                                .accentColor(.buttonMain)
        )
        .sheet(isPresented: $presentingLogin) {
            NavigationView {
                LoginView(viewModel: LoginViewModel(userState: userState))
            }
            .environmentObject(userState)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    static let userState = UserState()
    
    static var previews: some View {
        NavigationView {
            SettingsView(viewModel: SettingsViewModel(userState: userState))
                .environmentObject(userState)
        }
    }
}
