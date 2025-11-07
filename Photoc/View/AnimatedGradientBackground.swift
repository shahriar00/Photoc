//
//  AnimatedGradientBackground.swift
//  Photoc
//
//  Created by Shahriar Islam Sazid on 10/1/25.
//

import SwiftUI

struct AnimatedGradientBackground: View {
    @State private var animateGradient = false
    @State private var bubbles: [GlassBubble] = []
    
    var body: some View {
        ZStack {
            
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.0, green: 0.7, blue: 0.8),
                        Color(red: 0.0, green: 0.5, blue: 0.9),
                        Color(red: 0.1, green: 0.8, blue: 0.85)
                    ],
                    startPoint: animateGradient ? .topLeading : .bottomLeading,
                    endPoint: animateGradient ? .bottomTrailing : .topTrailing
                )
                
                RadialGradient(
                    colors: [
                        Color(red: 0.0, green: 0.85, blue: 0.9).opacity(0.4),
                        Color.clear
                    ],
                    center: animateGradient ? .topTrailing : .bottomLeading,
                    startRadius: 50,
                    endRadius: 600
                )
                
                RadialGradient(
                    colors: [
                        Color(red: 0.0, green: 0.6, blue: 1.0).opacity(0.4),
                        Color.clear
                    ],
                    center: animateGradient ? .bottomLeading : .topTrailing,
                    startRadius: 50,
                    endRadius: 600
                )
            }
            
            
            ForEach(bubbles) { bubble in
                GlassBubbleView(bubble: bubble)
            }
        }
        .ignoresSafeArea()
        .onAppear {
       
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
           
            createBubbles()
        }
    }
    
    private func createBubbles() {
        bubbles = (0..<8).map { index in
            GlassBubble(
                id: index,
                size: CGFloat.random(in: 100...250),
                x: CGFloat.random(in: -50...UIScreen.main.bounds.width + 50),
                y: CGFloat.random(in: -50...UIScreen.main.bounds.height + 50),
                duration: Double.random(in: 8...15),
                delay: Double.random(in: 0...3)
            )
        }
    }
}

struct GlassBubble: Identifiable {
    let id: Int
    let size: CGFloat
    let x: CGFloat
    let y: CGFloat
    let duration: Double
    let delay: Double
}

struct GlassBubbleView: View {
    let bubble: GlassBubble
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.3
    
    var body: some View {
                    Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color(red: 0.85, green: 0.98, blue: 1.0).opacity(0.5),
                        Color(red: 0.4, green: 0.92, blue: 0.98).opacity(0.25),
                        Color(red: 0.2, green: 0.8, blue: 0.95).opacity(0.15)
                    ],
                    center: .topLeading,
                    startRadius: 5,
                    endRadius: bubble.size * 0.7
                )
            )
            .frame(width: bubble.size, height: bubble.size)
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 0.7, green: 0.95, blue: 1.0).opacity(0.7),
                                Color(red: 0.3, green: 0.85, blue: 0.98).opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: Color(red: 0.0, green: 0.85, blue: 0.95).opacity(0.5), radius: 15, x: 0, y: 0)
            .shadow(color: Color(red: 0.2, green: 0.7, blue: 1.0).opacity(0.35), radius: 8, x: 5, y: 5)
            .blur(radius: 0.5)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(offset)
            .position(x: bubble.x, y: bubble.y)
            .onAppear {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        // Floating animation
        withAnimation(
            .easeInOut(duration: bubble.duration)
            .repeatForever(autoreverses: true)
            .delay(bubble.delay)
        ) {
            offset = CGSize(
                width: CGFloat.random(in: -100...100),
                height: CGFloat.random(in: -100...100)
            )
        }
        
        // Scale pulse animation
        withAnimation(
            .easeInOut(duration: bubble.duration * 0.6)
            .repeatForever(autoreverses: true)
            .delay(bubble.delay)
        ) {
            scale = CGFloat.random(in: 0.9...1.2)
        }
        
        // Opacity pulse animation
        withAnimation(
            .easeInOut(duration: bubble.duration * 0.4)
            .repeatForever(autoreverses: true)
            .delay(bubble.delay + 0.5)
        ) {
            opacity = Double.random(in: 0.2...0.5)
        }
    }
}

// Preview
#Preview {
    AnimatedGradientBackground()
}
