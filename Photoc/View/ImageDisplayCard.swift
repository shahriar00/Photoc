struct ImageDisplayCard: View {
    let selectedImage: UIImage?
    let convertedImage: UIImage?
    @Binding var showingImagePicker: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)
            
            if let image = convertedImage ?? selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
                    .padding(10)
                    .transition(.scale.combined(with: .opacity))
            } else {
                VStack(spacing: 15) {
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("Tap to select an image")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("or use the button below")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .frame(height: 320)
        .onTapGesture {
            showingImagePicker = true
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: selectedImage)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: convertedImage)
    }
}