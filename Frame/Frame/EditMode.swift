import SwiftUI

struct EditMode: View {
    @EnvironmentObject var cart: Cart
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var selectedImageIndex: Int = 0
    @State private var showFullScreen = false
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var selectedImages: Set<Int> = []
    @State private var hiddenImages: Set<Int> = []

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

                    Text("Select the images to remove from cart")
                        .font(Font.custom("Papyrus", size: 22))
                        .foregroundColor(.white)
                        .padding(.bottom, 0)

                    ScrollView(.vertical) {
                        GalleryGrid(
                            imageNames: cart.items.enumerated().compactMap { index, item in
                                hiddenImages.contains(index) ? nil : item.imageName
                            },
                            selectedImageIndex: $selectedImageIndex,
                            showFullScreen: $showFullScreen,
                            scale: $scale,
                            lastScale: $lastScale,
                            offset: $offset,
                            lastOffset: $lastOffset,
                            selectedImages: $selectedImages,
                            editMode: .constant(true),
                            checkout: .constant(false)
                        )
                        .environmentObject(cart)
                    }
                    .padding(.bottom, 15)

                    HStack {
                        Button(action: {
                            if selectedImages.isEmpty {
                                cart.items.removeAll { hiddenImages.contains(cart.items.firstIndex(of: $0)!) }
                                hiddenImages.removeAll()
                                self.presentationMode.wrappedValue.dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    NotificationCenter.default.post(name: Notification.Name("NavigateToCart"), object: nil)
                                }
                            } else {
                                hiddenImages.formUnion(selectedImages)
                                selectedImages.removeAll()
                            }
                        }) {
                            Text(selectedImages.isEmpty ? "Done" : "Delete")
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.bottom, 20)

                    Spacer()
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: geometry.size.width * 0.6, height: 2)
                        .padding(.bottom, 5)

                    SocialMediaLinks()
                        .padding(.bottom, 20)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true)
    }
}

struct EditMode_Previews: PreviewProvider {
    static var previews: some View {
        EditMode()
            .environmentObject(Cart())
    }
}
