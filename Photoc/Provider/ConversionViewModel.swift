//
//  ConversionViewModel.swift
//  Photoc
//
//  Created by Shahriar Islam Sazid on 10/1/25.
//

import Foundation
import Combine
import SwiftUI
import Photos

class ConversionViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var convertedImage: UIImage?
    @Published var selectedFormat: ImageFormat = .jpeg
    @Published var showingImagePicker = false
    @Published var showingConversionProgress = false
    @Published var showingConversionComplete = false
    @Published var showingShareSheet = false
    @Published var conversionProgress: Double = 0.0
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    init() {
        // Clear converted image when new image is selected
        $selectedImage
            .sink { [weak self] _ in
                self?.convertedImage = nil
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var conversionTimer: Timer?
    
    func convertImage() {
        guard let inputImage = selectedImage else { return }
        
        showingConversionProgress = true
        conversionProgress = 0.0
        
        conversionTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            self.conversionProgress = min(self.conversionProgress + 0.05, 1.0)
            
            if self.conversionProgress >= 1.0 {
                timer.invalidate()
                self.showingConversionProgress = false
                self.convertedImage = self.performConversion(inputImage)
                self.showingConversionComplete = true
            }
        }
    }
    
    private func performConversion(_ image: UIImage) -> UIImage {
        switch selectedFormat {
        case .jpeg:
            if let data = image.jpegData(compressionQuality: 0.9),
               let converted = UIImage(data: data) {
                return converted
            }
        case .png:
            if let data = image.pngData(),
               let converted = UIImage(data: data) {
                return converted
            }
        }
        return image
    }
    
    func saveToPhotos() {
        guard let imageToSave = convertedImage else { return }
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
            guard let self = self else { return }
            
            switch status {
            case .authorized, .limited:
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: imageToSave)
                }) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            self.alertMessage = "Image saved to Photos successfully! ✨"
                        } else if let error = error {
                            self.alertMessage = "Error: \(error.localizedDescription)"
                        } else {
                            self.alertMessage = "Unknown error occurred"
                        }
                        self.showingAlert = true
                    }
                }
            case .denied, .restricted:
                DispatchQueue.main.async {
                    self.alertMessage = "Photos access denied. Enable it in Settings."
                    self.showingAlert = true
                }
            case .notDetermined:
                DispatchQueue.main.async {
                    self.alertMessage = "Please try again to grant access."
                    self.showingAlert = true
                }
            @unknown default:
                DispatchQueue.main.async {
                    self.alertMessage = "Unknown authorization status."
                    self.showingAlert = true
                }
            }
        }
    }
}
