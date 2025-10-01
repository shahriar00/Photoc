//
//  FormatButton.swift
//  Photoc
//
//  Created by Shahriar Islam Sazid on 10/1/25.
//
import SwiftUI

struct FormatButton: View {
    let format: ImageFormat
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: format == .jpeg ? "doc.fill" : "doc.richtext.fill")
                    .font(.title2)
                
                Text(format.rawValue.uppercased())
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? .white : .white.opacity(0.2))
                    .shadow(color: isSelected ? .white.opacity(0.5) : .clear, radius: 10, x: 0, y: 0)
            )
            .foregroundColor(isSelected ? Color(red: 0.2, green: 0.6, blue: 0.9) : .white)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? .white : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
