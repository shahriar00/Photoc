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
    
    @State private var selectedImage: UIImage?
    @State private var convertedImage: UIImage?
    @State private var selectedFormat: ImageFormat = .jpeg
    @State private var showingImagePicker = false
    @State private var showingConversionProgress = false
    @State private var showingConversionComplete = false
    @State private var showingShareSheet = false
    @State private var conversionProgress: Double = 0.0
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let imageFormats: [ImageFormat] = [.jpeg, .png]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                Text("Photo Converter")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Image Display Area
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 300)
                    
                    if let image = convertedImage ?? selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 280)
                            .cornerRadius(12)
                    } else {
                        VStack {
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("Select an image to convert")
                                .foregroundColor(.gray)
                                .padding(.top)
                        }
                    }
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                
                // Select Image Button
                Button(action: {
                    showingImagePicker = true
                }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                        Text("Select Image")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                
                // Format Selection
                if selectedImage != nil {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Convert to:")
                            .font(.headline)
                            .padding(.leading)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                            ForEach(imageFormats, id: \.self) { format in
                                Button(action: {
                                    selectedFormat = format
                                }) {
                                    Text(format.rawValue.uppercased())
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedFormat == format ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(selectedFormat == format ? .white : .primary)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Convert Button
                    Button(action: {
                        convertImage()
                    }) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                            Text("Convert to \(selectedFormat.rawValue.uppercased())")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if convertedImage != nil {
                        Button(action: {
                            saveToPhotos()
                        }) {
                            Image(systemName: "square.and.arrow.down")
                        }
                        
                        Button(action: {
                            showingShareSheet = true
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .onChange(of: selectedImage) { _ in
            // Clear converted image when new image is selected
            convertedImage = nil
        }
        .sheet(isPresented: $showingShareSheet) {
            if let convertedImage = convertedImage {
                ShareSheet(items: [convertedImage])
            }
        }
        .alert("Conversion Progress", isPresented: $showingConversionProgress) {
            Button("Cancel") {
                showingConversionProgress = false
            }
        } message: {
            VStack {
                ProgressView(value: min(max(conversionProgress, 0.0), 1.0), total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                Text("Converting... \(Int(min(max(conversionProgress, 0.0), 1.0) * 100))%")
            }
        }
        .alert("Conversion Complete!", isPresented: $showingConversionComplete) {
            Button("OK") {
                showingConversionComplete = false
            }
        } message: {
            Text("Your image has been converted to \(selectedFormat.rawValue.uppercased()) format successfully!")
        }
        .alert("Alert", isPresented: $showingAlert) {
            Button("OK") {
                showingAlert = false
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    func convertImage() {
        guard let inputImage = selectedImage else { return }
        
        showingConversionProgress = true
        conversionProgress = 0.0
        
        // Simulate conversion progress
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            conversionProgress = min(conversionProgress + 0.1, 1.0)
            
            if conversionProgress >= 1.0 {
                timer.invalidate()
                showingConversionProgress = false
                
                // Perform actual conversion
                let convertedUIImage = convertImageToFormat(inputImage, format: selectedFormat)
                convertedImage = convertedUIImage
                
                showingConversionComplete = true
            }
        }
    }
    
    func convertImageToFormat(_ image: UIImage, format: ImageFormat) -> UIImage {
        switch format {
        case .jpeg:
            if let data = image.jpegData(compressionQuality: 0.9),
               let convertedImage = UIImage(data: data) {
                return convertedImage
            }
        case .png:
            if let data = image.pngData(),
               let convertedImage = UIImage(data: data) {
                return convertedImage
            }
        }
            
        return image
        
    }
        
    func saveToPhotos() {
        guard let imageToSave = convertedImage else { return }
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            switch status {
            case .authorized, .limited:
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: imageToSave)
                }) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            alertMessage = "Image saved to Photos successfully!"
                        } else if let error = error {
                            alertMessage = "Error saving image: \(error.localizedDescription)"
                        } else {
                            alertMessage = "Unknown error occurred while saving"
                        }
                        showingAlert = true
                    }
                }
            case .denied, .restricted:
                DispatchQueue.main.async {
                    alertMessage = "Photos access denied. Please enable it in Settings."
                    showingAlert = true
                }
            case .notDetermined:
                DispatchQueue.main.async {
                    alertMessage = "Photos access not determined. Please try again."
                    showingAlert = true
                }
            @unknown default:
                DispatchQueue.main.async {
                    alertMessage = "Unknown authorization status."
                    showingAlert = true
                }
            }
        }
    }
        
    }

#Preview {
    HomeView()
}
