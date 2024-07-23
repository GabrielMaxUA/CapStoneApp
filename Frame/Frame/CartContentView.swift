import SwiftUI

struct CartContentView: View {
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

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                Image("mainBack") // Replace with your image name
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 1.5, height: geometry.size.height * 1.5)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HeaderView(geometry: geometry, showChevron: true, showCart: false, onBack: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    .padding(.top, 55)
                    
                    Text(title) // Displays the title
                        .font(Font.custom("Papyrus", size: 30)) // Sets custom font and size
                        .foregroundColor(.white) // Sets text color to white
                        .padding(.bottom, 0)
                        .padding(.top, -5) // Adds bottom padding
                    if cart.items.isEmpty {
                        Text("Your Cart is empty.")
                            .font(Font.custom("Papyrus", size: 35)) // Sets custom font and size
                            .foregroundColor(.white) // Sets text color to white
                            .padding(.top, 100)
                    } else {
                        ScrollView(.vertical) {
                            GalleryGrid(
                                imageNames: cart.items.map { $0.imageName },
                                selectedImageIndex: $selectedImageIndex,
                                showFullScreen: $showFullScreen,
                                scale: $scale,
                                lastScale: $lastScale,
                                offset: $offset,
                                lastOffset: $lastOffset
                            )
                            .environmentObject(cart)
                        }
                        .padding(.bottom, 15)

                        VStack {
                            Button(action: {
                                // Add your action here
                            }) {
                                Text("Check Out")
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.bottom, 20)
                            
                            // Separator line
                            Rectangle() // Rectangle shape
                                .fill(Color.white) // Fills the rectangle with white color
                                .frame(width: geometry.size.width * 0.6, height: 2) // Sets the frame of the rectangle
                                .padding(.bottom, 5) // Adds padding

                            // Social media links
                            SocialMediaLinks()
                                .padding(.bottom, 20)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                if showFullScreen {
                    FullScreenImageView(
                        imageName: cart.items[safe: selectedImageIndex]?.imageName ?? "",
                        geometry: geometry,
                        onBack: { self.showFullScreen = false },
                        showFullScreen: $showFullScreen,
                        scale: $scale,
                        lastScale: $lastScale,
                        offset: $offset,
                        lastOffset: $lastOffset,
                        showCrossButton: $showCrossButton,
                        selectedImageIndex: $selectedImageIndex,
                        showCartIcon: false,
                        imageNames: imageNames
                    )
                    .environmentObject(cart)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true) // Hide the system back button
    }
}

struct CartContentView_Previews: PreviewProvider {
    static var previews: some View {
        CartContentView(title: "Cart", imageNames: ["image1", "image2"])
            .environmentObject(Cart())
    }
}

// Add this extension to safely access array elements
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
