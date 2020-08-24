//
//  HeaderView.swift
//  HypeLove
//
//  Created by Jaume on 24/08/2020.
//

import SwiftUI

struct HeaderView: View {
    
    let title: String
    let action: () -> ()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .frame(alignment: .leading)
                    .padding()
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .padding()
            }
            .font(Font.title2.bold())
        }
        .modifier(MakeButton {
            action()
        })
        
    }
    
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Popular", action: {})
    }
}
