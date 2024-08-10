import SwiftUI

struct GalleryView: View {
    let title: String // Title of the gallery
    let imageNames: [String] // Names of the images in the gallery
    @EnvironmentObject var cart: Cart // Access Cart instance from environment
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // Environment variable to handle presentation mode
    @State private var selectedImageIndex: Int = 0 // State variable for the selected image index
    @State private var showFullScreen = false // State variable for full-screen view
    @State private var scale: CGFloat = 1.0 // State variable for image scale
    @State private var lastScale: CGFloat = 1.0 // State variable for last image scale
    @State private var offset: CGSize = .zero // State variable for image offset
    @State private var lastOffset: CGSize = .zero // State variable for last image offset
    @State private var showCrossButton = true // State variable for cross button visibility
    
    var body: some View {
        GeometryReader { geometry in
            Image("mainBack")
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width * 1.5, height: geometry.size.height * 1.5)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .edgesIgnoringSafeArea(.all)
            ZStack {
                VStack(spacing: 0) {
                    HeaderView(geometry: geometry, showChevron: true, showCart: true, onBack: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    .padding(.top, 55)

                    Text(title)
                        .font(Font.custom("Papyrus", size: 30))
                        .foregroundColor(.white)
                        .padding(.bottom, 0)

                    ScrollView(.vertical) {
                        GalleryGrid(
                            imageNames: filteredImageNames(),
                            selectedImageIndex: $selectedImageIndex,
                            showFullScreen: $showFullScreen,
                            scale: $scale,
                            lastScale: $lastScale,
                            offset: $offset,
                            lastOffset: $lastOffset,
                            selectedImages: .constant([]),
                            editMode: .constant(false),
                            checkout: .constant(false)
                        )
                        .environmentObject(cart)
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: geometry.size.width * 0.6, height: 2)
                            .padding(.bottom, 5)

                        SocialMediaLinks()
                            .padding(.bottom, 20)
                    }

                  
                }

                if showFullScreen {
                    FullScreenImageView(
                        imageName: filteredImageNames()[selectedImageIndex],
                                            geometry: geometry,
                                            onBack: { self.showFullScreen = false },
                                            showFullScreen: $showFullScreen,
                                            scale: $scale,
                                            lastScale: $lastScale,
                                            offset: $offset,
                                            lastOffset: $lastOffset,
                                            showCrossButton: $showCrossButton,
                                            selectedImageIndex: $selectedImageIndex,
                                            showCartIcon: true,
                                            imageNames: filteredImageNames()
                    )
                    .environmentObject(cart)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true)
    }
    
    private func filteredImageNames() -> [String] {
        return imageNames.filter { imageName in
            !cart.items.contains { $0.imageName == imageName && $0.isCheckedOut }
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(
            title: "Nature",
            imageNames: ["Npic1", "Npic2", "Npic3", "Npic4", "Npic5", "Npic6", "Npic7", "Npic8", "Npic9", "Npic10", "Npic11", "Npic13", "Npic12"]
        )
        .environmentObject(Cart())
        .previewDisplayName("Nature Gallery")
        
        GalleryView(
            title: "Models",
            imageNames: ["Mpic1", "Mpic2", "Mpic3", "Mpic4", "Mpic5", "Mpic6", "Mpic7", "Mpic8", "Mpic9", "Mpic10", "Mpic11", "Mpic12", "Mpic13", "Mpic14"]
        )
        .environmentObject(Cart())
        .previewDisplayName("Models Gallery")
        
        GalleryView(
            title: "Architecture",
            imageNames: ["Apic1", "Apic2", "Apic3", "Apic4", "Apic5", "Apic6", "Apic7", "Apic8", "Apic9", "Apic10"]
        )
        .environmentObject(Cart())
    }
}
