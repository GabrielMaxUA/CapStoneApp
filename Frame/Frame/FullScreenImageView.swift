import SwiftUI

struct FullScreenImageView: View {
    let imageName: String
    let geometry: GeometryProxy
    let onBack: () -> Void
    @Binding var showFullScreen: Bool
    @Binding var scale: CGFloat
    @Binding var lastScale: CGFloat
    @Binding var offset: CGSize
    @Binding var lastOffset: CGSize
    @Binding var showCrossButton: Bool
    @Binding var selectedImageIndex: Int
    @State var showCartIcon: Bool
    let imageNames: [String]
    @EnvironmentObject var cart: Cart
    @State private var showAddButton = true
    @State private var showCameraView = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        ZStack {
            if showCameraView {
                CameraView(imageName: imageName, geometry: geometry) {
                    showCameraView = false
                }
                .edgesIgnoringSafeArea(.all)
            } else {
                Color.black.edgesIgnoringSafeArea(.all)
                let screenCenter = CGSize(width: geometry.size.width / 2, height: geometry.size.height / 2)
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * scale)
                        .clipped()
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = lastScale * value.magnitude
                        }
                        .onEnded { value in
                            lastScale = scale
                        }
                )
                .gesture(
                    TapGesture(count: 2)
                        .onEnded {
                            withAnimation {
                                if scale > 1 {
                                    scale = 1
                                    lastScale = 1
                                } else {
                                    scale = 3
                                    let newOffset = CGSize(
                                        width: screenCenter.width - (screenCenter.width / scale),
                                        height: screenCenter.height - (screenCenter.height / scale)
                                    )
                                    offset = newOffset
                                }
                            }
                        }
                )
                .gesture(
                    TapGesture(count: 1)
                        .onEnded {
                            withAnimation {
                                showCrossButton.toggle()
                            }
                        }
                )

                GeometryReader { geo in
                    VStack {
                        if showCrossButton {
                            if showCartIcon {
                                HStack {
                                    if !cart.items.isEmpty {
                                        ZStack {
                                            NavigationLink(destination: CartContentView(title: "Cart", imageNames: cart.items.map { $0.imageName }).environmentObject(cart)) {
                                                Image(systemName: "cart")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 27, height: 27)
                                                    .foregroundColor(.white)
                                            }
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 10)
                                                .offset(x: 2.5, y: -5)
                                        }
                                        .padding(.leading, 20)
                                    } else {
                                        Rectangle()
                                            .fill(Color.clear)
                                            .frame(width: 27, height: 27)
                                    }
                                    Spacer()
                                    Button(action: {
                                        showFullScreen = false
                                        scale = 1.0
                                        lastScale = 1.0
                                        offset = .zero
                                        lastOffset = .zero
                                    }) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 27))
                                    }
                                    .padding(.trailing, 20)
                                }
                                .padding(.top, 50)
                                .frame(width: geo.size.width, alignment: .top)
                            } else {
                                HStack {
                                    Button(action: {
                                        onBack()
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.white)
                                            .font(.system(size: 27))
                                            .padding(.leading, 20)
                                    }
                                    Spacer()
                                    Button(action: {
                                        showFullScreen = false
                                        scale = 1.0
                                        lastScale = 1.0
                                        offset = .zero
                                        lastOffset = .zero
                                    }) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 27))
                                    }
                                    .padding(.trailing, 20)
                                }
                                .padding(.top, 50)
                                .frame(width: geo.size.width, alignment: .top)
                            }
                            
                            Spacer()
                            
                            HStack {
                                if selectedImageIndex > 0 {
                                    Button(action: {
                                        if selectedImageIndex > 0 {
                                            selectedImageIndex -= 1
                                            scale = 1
                                            showAddButton = !cart.isInCart(imageName: imageNames[selectedImageIndex])
                                        }
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.white)
                                            .font(.system(size: 34))
                                            .padding()
                                    }
                                }
                                Spacer()
                                if selectedImageIndex < imageNames.count - 1 {
                                    Button(action: {
                                        if selectedImageIndex < imageNames.count - 1 {
                                            selectedImageIndex += 1
                                            scale = 1
                                            showAddButton = !cart.isInCart(imageName: imageNames[selectedImageIndex])
                                        }
                                    }) {
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                            .font(.system(size: 34))
                                            .padding()
                                    }
                                }
                            }
                            .frame(width: geo.size.width, height: geo.size.height / 2, alignment: .center)
                            
                            Spacer()
                            
                            HStack(spacing: 20) {
                                if showAddButton {
                                    Button(action: {
                                        cart.addItem(imageName: imageName)
                                        showAddButton = false // Hide the button after adding to the cart
                                    }) {
                                        Text("Add to Cart")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                            .padding()
                                            .background(Color.gray)
                                            .cornerRadius(10)
                                    }
                                }
                                Button(action: {
                                    // Try it On action
                                    showCameraView = true
                                }) {
                                    Text("Try it On")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .padding()
                                        .background(Color.gray)
                                        .cornerRadius(10)
                                }
                            }
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarHidden(true)
                }
                .frame(height: geometry.size.height)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            showAddButton = !cart.isInCart(imageName: imageName)
        }
        .onRotate { newOrientation in
            adjustForOrientation(newOrientation)
        }
    }

    private func adjustForOrientation(_ orientation: UIDeviceOrientation) {
        if orientation.isLandscape {
            // Adjust the UI for landscape mode
            withAnimation {
                showCartIcon = false
            }
        } else if orientation.isPortrait {
            // Adjust the UI for portrait mode
            withAnimation {
                showCartIcon = true
            }
        }
    }
}
