//
//  HomeView.swift
//  Photoc
//
//  Created by Shahriar Islam Sazid on 9/20/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
import Photos

struct HomeView: View {
    
    @StateObject private var viewModel = ConversionViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
             
                AnimatedGradientBackground()
                
                ScrollView {
                    VStack(spacing: 30) {
                       
                        HeaderSection()
                      
                        ImageDisplayCard(
                            selectedImage: viewModel.selectedImage,
                            convertedImage: viewModel.convertedImage,
                            showingImagePicker: $viewModel.showingImagePicker
                        )
                       
                        if viewModel.selectedImage != nil {
                            FormatSelectionSection(viewModel: viewModel)
                            
                            ConvertButton(viewModel: viewModel)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if viewModel.convertedImage != nil {
                        ToolbarButtons(viewModel: viewModel)
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(image: $viewModel.selectedImage)
        }
        .sheet(isPresented: $viewModel.showingShareSheet) {
            if let image = viewModel.convertedImage {
                ShareSheet(items: [image])
            }
        }
        .alert("Success!", isPresented: $viewModel.showingConversionComplete) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Image converted to \(viewModel.selectedFormat.rawValue.uppercased()) successfully! ✨")
        }
        .alert("Alert", isPresented: $viewModel.showingAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
        .overlay {
            if viewModel.showingConversionProgress {
                ConversionProgressOverlay(progress: viewModel.conversionProgress)
            }
        }
    }
}


#Preview {
    HomeView()
}
