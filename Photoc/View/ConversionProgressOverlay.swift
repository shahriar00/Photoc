// MARK: - Conversion Progress Overlay
struct ConversionProgressOverlay: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
                
                Text("Converting...")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(.linear)
                    .tint(.white)
                    .frame(width: 200)
                
                Text("\(Int(progress * 100))%")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
            )
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        }
        .transition(.opacity)
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}