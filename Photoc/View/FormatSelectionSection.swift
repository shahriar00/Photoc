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