//
//  AnimatableGradient.swift
//  HypeLove
//
//  Created by Jaume on 12/08/2020.
//

import SwiftUI

struct AnimatableGradient: View {
    @State var startColor: Color
    @State var endColor: Color
    @State var reversedPoints = false
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [startColor, endColor]),
                       startPoint:  reversedPoints ? .init(x: 0.01, y: 0) : .init(x: 0, y: 0),
                       endPoint: reversedPoints ? .init(x: 1, y: 0) : .init(x: 0.01, y: 0))
            .animation(Animation.easeInOut(duration : 2).repeatForever(autoreverses: true))
            .onAppear {
                reversedPoints.toggle()
            }
    }
}

struct AnimatableGradient_Previews: PreviewProvider {
    static var previews: some View {
        AnimatableGradient(startColor: .black, endColor: .gray)
            .frame(maxHeight: 50)
            .padding()
    }
}
