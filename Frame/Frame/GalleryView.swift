import SwiftUI

struct GalleryView: View {
    let title: String // Title of the gallery
    let imageNames: [String] // Names of the images in the gallery
    @EnvironmentObject var cart: Cart // Access Cart instance from environment
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // Environment variable to handle presentation mode
    @State private var selectedImageIndex: Int = 0 // State variable for the selected image index
    @State private var showFullScreen = false // State variable for full-screen view
    @State private var showCrossButton = true // State variable for cross button visibility
    @State private var scale: CGFloat = 1.0 // State variable for image scale
    @State private var lastScale: CGFloat = 1.0 // State variable for last image scale
    @State private var offset: CGSize = .zero // State variable for image offset
    @State private var lastOffset: CGSize = .zero // State variable for last image offset
    @State private var showCartIcon = true
    let scrollToTop: () -> Void // Callback to scroll to the top of the content
    @State private var showButton = true
    
    var body: some View {
        GeometryReader { geometry in // GeometryReader to get the size of the parent container
            Image("mainBack")
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width * 1.5, height: geometry.size.height * 1.5)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .edgesIgnoringSafeArea(.all)
            ZStack { // ZStack to overlay views
                // Background and gallery content based on the title
                if title == "Nature" { // Checks if the title is "Nature"
                    contentView(geometry: geometry) { // Calls contentView with natureGallery content
                        self.natureGallery()
                    }
                } else if self.title == "Architecture" { // Checks if the title is "Architecture"
                    self.contentView(geometry: geometry) { // Calls contentView with architectureGallery content
                        self.architectureGallery()
                    }
                } else if self.title == "Models" { // Checks if the title is "Models"
                    self.contentView(geometry: geometry) { // Calls contentView with modelsGallery content
                        self.modelsGallery()
                    }
                }
                
                // Full-screen image view
                if showFullScreen { // Checks if full-screen view is enabled
                    FullScreenImageView(
                        imageName: imageNames[selectedImageIndex],
                        geometry: geometry,
                        onBack: { self.showFullScreen = false },
                        showFullScreen: $showFullScreen,
                        scale: $scale,
                        lastScale: $lastScale,
                        offset: $offset,
                        lastOffset: $lastOffset,
                        showCrossButton: $showCrossButton,
                        selectedImageIndex: $selectedImageIndex, showCartIcon: true,
                        imageNames: imageNames
                    )
                    .environmentObject(cart)
                }
            }
            .edgesIgnoringSafeArea(.all) // Makes the ZStack ignore safe area edges
        }
        .navigationBarHidden(true) // Hides the navigation bar
    }
    
    private func contentView<Content: View>(geometry: GeometryProxy, @ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(spacing: 0) { // Vertical stack for content
            HeaderView(geometry: geometry, showChevron: true, showCart: true, onBack: {
                self.presentationMode.wrappedValue.dismiss()
            })
            .padding(.top, 55)
            
            // Gallery title
            HStack { // Horizontal stack for title
                Text(title) // Displays the title
                    .font(Font.custom("Papyrus", size: 30)) // Sets custom font and size
                    .foregroundColor(.white) // Sets text color to white
                    .padding(.bottom, 0) // Adds bottom padding
            }
            
            ScrollView(.vertical) { // Vertical scroll view
                VStack(spacing: 0) { // Vertical stack for gallery content with no spacing
                    content() // Calls the content view builder
                    
                    // Separator line
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: geometry.size.width * 0.6, height: 2)
                    
                    SocialMediaLinks()
                        .padding(.top, 20)
                }
            }
        }
        .padding(.bottom, 15)
    }
    
    private func natureGallery() -> some View {
            GalleryGrid(
                imageNames: imageNames,
                selectedImageIndex: $selectedImageIndex,
                showFullScreen: $showFullScreen,
                scale: $scale,
                lastScale: $lastScale,
                offset: $offset,
                lastOffset: $lastOffset
            )
            .environmentObject(cart)
        }
        
        @ViewBuilder
        private func architectureGallery() -> some View {
            GalleryGrid(
                imageNames: imageNames,
                selectedImageIndex: $selectedImageIndex,
                showFullScreen: $showFullScreen,
                scale: $scale,
                lastScale: $lastScale,
                offset: $offset,
                lastOffset: $lastOffset
            )
            .environmentObject(cart)
        }
        
        @ViewBuilder
        private func modelsGallery() -> some View {
            GalleryGrid(
                imageNames: imageNames,
                selectedImageIndex: $selectedImageIndex,
                showFullScreen: $showFullScreen,
                scale: $scale,
                lastScale: $lastScale,
                offset: $offset,
                lastOffset: $lastOffset
            )
            .environmentObject(cart)
        }

}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GalleryView(
                title: "Nature",
                imageNames: ["Npic1", "Npic2", "Npic3", "Npic4", "Npic5", "Npic6", "Npic7", "Npic8", "Npic9", "Npic10", "Npic11", "Npic13", "Npic12", "Npic14"],
                scrollToTop: {}
            )
            .environmentObject(Cart())
            .previewDisplayName("Nature Gallery")
            
            GalleryView(
                title: "Models",
                imageNames: ["Mpic1", "Mpic2", "Mpic3", "Mpic4", "Mpic5", "Mpic6", "Mpic7", "Mpic8", "Mpic9", "Mpic10", "Mpic11", "Mpic12", "Mpic13", "Mpic14"],
                scrollToTop: {}
            )
            .environmentObject(Cart())
            .previewDisplayName("Models Gallery")
            
            GalleryView(
                title: "Architecture",
                imageNames: ["Apic1", "Apic2", "Apic3", "Apic4", "Apic5", "Apic6", "Apic7", "Apic8", "Apic9", "Apic10"],
                scrollToTop: {}
            )
            .environmentObject(Cart())
            .previewDisplayName("Architecture Gallery")
            
            GeometryReader { geometry in
                HeaderView(geometry: geometry, showChevron: true, showCart: true, onBack: {})
                    .environmentObject(Cart())
            }
            .previewDisplayName("Header View")
            
            CartContentView(title: "Cart", imageNames: ["Npic1", "Npic2", "Npic3"])
                .environmentObject(Cart())
                .previewDisplayName("Cart Content View")
        }
    }
}
