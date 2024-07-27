import SwiftUI

struct CartContentView: View {
    let title: String // Title of the gallery
    let imageNames: [String] // Names of the images in the gallery
    @EnvironmentObject var cart: Cart // Access Cart instance from environment

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // Environment variable to handle presentation mode
    @State private var selectedImageIndex: Int = 0 // State variable for the selected image index
    @State private var showFullScreen = false // State variable for full-screen view
    @State private var editCart = false // State variable for edit mode
    @State private var checkout = false // State variable for checkout mode
    @State private var selectedImages: Set<Int> = [] // State variable for selected images
    @State private var scale: CGFloat = 1.0 // State variable for image scale
    @State private var lastScale: CGFloat = 1.0 // State variable for last image scale
    @State private var offset: CGSize = .zero // State variable for image offset
    @State private var lastOffset: CGSize = .zero // State variable for last image offset
    @State private var showCrossButton = true // State variable for cross button visibility

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                Image("mainBack")
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

                    Text(title)
                        .font(Font.custom("Papyrus", size: 30))
                        .foregroundColor(.white)
                        .padding(.bottom, 0)

                    if cart.items.isEmpty {
                        Text("Your Cart is empty.")
                            .font(Font.custom("Papyrus", size: 35))
                            .foregroundColor(.white)
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
                                lastOffset: $lastOffset,
                                selectedImages: $selectedImages,
                                editMode: $editCart,
                                checkout: $checkout
                            )
                            .environmentObject(cart)
                        }
                        .padding(.bottom, 15)

                        VStack {
                            if editCart {
                                HStack {
                                    Button(action: {
                                        for index in selectedImages {
                                            if let imageName = cart.items[safe: index]?.imageName {
                                                cart.removeItem(imageName: imageName)
                                            }
                                        }
                                        editCart = false
//                                        selectedImages.removeAll()
                                    }) {
                                        Text("Delete")
                                            .padding()
                                            .background(Color.gray)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    Button(action: {
                                        for index in selectedImages {
                                            if let imageName = cart.items[safe: index]?.imageName {
                                                cart.removeItem(imageName: imageName)
                                            }
                                        }
                                        editCart = false
//                                        selectedImages.removeAll()
                                    }) {
                                        Text("Done")
                                            .padding()
                                            .background(Color.gray)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                }
                                .padding(.bottom, 20)
                            } else {
                                HStack {
                                    Button(action: {
                                        editCart = true
                                    }) {
                                        Text("Edit Cart")
                                            .padding()
                                            .background(Color.gray)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    NavigationLink(destination: Checkout(imageNames: cart.items.map { $0.imageName }).environmentObject(cart)) {
                                            Text("Check Out")
                                            .padding()
                                            .background(Color.gray)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                }
                                .padding(.bottom, 20)
                            
                            }

                        }
                        .frame(maxWidth: .infinity)
                    }
                    Spacer()
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: geometry.size.width * 0.6, height: 2)
                        .padding(.bottom, 5)

                    SocialMediaLinks()
                        .padding(.bottom, 20)

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
        .navigationBarHidden(true)
    }
}

struct CartContentView_Previews: PreviewProvider {
    static var previews: some View {
        CartContentView(title: "Cart", imageNames: ["Npic1", "Npic2", "Npic3"])
            .environmentObject(Cart())
    }
}

// Add this extension to safely access array elements
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
