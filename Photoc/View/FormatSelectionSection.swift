//
//  FormatSelectionSection.swift
//  Photoc
//
//  Created by Shahriar Islam Sazid on 10/1/25.
//
import SwiftUI

struct FormatSelectionSection: View {
    @ObservedObject var viewModel: ConversionViewModel
    let formats: [ImageFormat] = [.jpeg, .png]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Convert to:")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
            
            HStack(spacing: 15) {
                ForEach(formats, id: \.self) { format in
                    FormatButton(
                        format: format,
                        isSelected: viewModel.selectedFormat == format,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                viewModel.selectedFormat = format
                            }
                        }
                    )
                }
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}


