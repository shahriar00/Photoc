//
//  GoogleButton.swift
//  Photoc
//
//  Created by Shahriar Islam Sazid on 9/26/25.
//

import SwiftUI

struct LoginButton: View {
    
    var onAction: () -> Void
    let image: String
    
    var body: some View {
        Button{
            onAction()
        }label:{
            ZStack{
                RoundedRectangle(cornerRadius: 18)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.4),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
                
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            .frame(width: 70, height: 70)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

