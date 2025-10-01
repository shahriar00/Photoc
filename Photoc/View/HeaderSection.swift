struct HeaderSection: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "photo.stack.fill")
                .font(.system(size: 50))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .white.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            Text("Photo Converter")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
            
            Text("Transform your images instantly")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(.top, 20)
    }
}