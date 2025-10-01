//
//  AnimatedGradientBackground.swift
//  Photoc
//
//  Created by Shahriar Islam Sazid on 10/1/25.
//

import SwiftUI

struct AnimatedGradientBackground: View {
    @State private var animateGradient = false
    
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.8, blue: 0.5),
                Color(red: 0.2, green: 0.6, blue: 0.9),
                Color(red: 0.3, green: 0.9, blue: 0.6)
            ],
            startPoint: animateGradient ? .topLeading : .bottomLeading,
            endPoint: animateGradient ? .bottomTrailing : .topTrailing
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}
