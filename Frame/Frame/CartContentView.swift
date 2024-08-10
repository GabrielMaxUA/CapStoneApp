import SwiftUI

struct CartContentView: View {
    let title: String
    let imageNames: [String]
    let pricePerImage: Double = 59.99
    
    @EnvironmentObject var cart: Cart

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedImageIndex: Int = 0
    @State private var showFullScreen = false
    @State private var checkout = false
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var showCrossButton = true
    

    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                                selectedImages: .constant([]),
                                editMode: .constant(false),
                                checkout: $checkout
                            )
                            .environmentObject(cart)
                        }
                        .padding(.bottom, 15)

                        HStack {
                            NavigationLink(destination: EditMode().environmentObject(cart)) {
                                Text("Edit Cart")
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            NavigationLink(destination: Checkout(imageNames: loadCartItemsFromUserDefaults()).environmentObject(cart)) {
                                Text("Check Out")
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    HStack {
                        Spacer()
                        Text("Total: $\(totalAmount(), specifier: "%.2f")")
                            .font(Font.custom("Papyrus", size: 24))
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                        Spacer()
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
    
    private func loadCartItemsFromUserDefaults() -> [String] {
        if let savedItems = UserDefaults.standard.data(forKey: "cartItems") {
            if let decodedItems = try? JSONDecoder().decode([CartItem].self, from: savedItems) {
                print("Loading cart items for checkout: \(decodedItems.map { $0.imageName })")
                return decodedItems.map { $0.imageName }
            }
        }
        return []
    }
    
    private func totalAmount() -> Double {
        let subtotal = Double(imageNames.count) * pricePerImage
        return subtotal
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
