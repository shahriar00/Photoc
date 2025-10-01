struct ToolbarButtons: View {
    @ObservedObject var viewModel: ConversionViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {
                viewModel.saveToPhotos()
            }) {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.title3)
                    .foregroundColor(.white)
            }
            
            Button(action: {
                viewModel.showingShareSheet = true
            }) {
                Image(systemName: "square.and.arrow.up.circle.fill")
                    .font(.title3)
                    .foregroundColor(.white)
            }
        }
    }
}
