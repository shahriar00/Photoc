//
//  ConvertButton.swift
//  Photoc
//
//  Created by Shahriar Islam Sazid on 10/1/25.
//
import SwiftUI

struct ConvertButton: View {
    @ObservedObject var viewModel: ConversionViewModel
    
    var body: some View {
        Button(action: {
            viewModel.convertImage()
        }) {
            HStack(spacing: 12) {
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .font(.title3)
                Text("Convert to \(viewModel.selectedFormat.rawValue.uppercased())")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.2, green: 0.9, blue: 0.5), Color(red: 0.1, green: 0.7, blue: 0.4)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(15)
            .shadow(color: Color(red: 0.2, green: 0.9, blue: 0.5).opacity(0.5), radius: 15, x: 0, y: 8)
        }
        .buttonStyle(ScaleButtonStyle())
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
