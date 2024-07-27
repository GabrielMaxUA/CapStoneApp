import SwiftUI

struct HeaderView: View {
    var geometry: GeometryProxy
    var showChevron: Bool // Add a parameter to control the chevron visibility
    var showCart: Bool
    var onBack: (() -> Void)? // Closure for back button action
    @EnvironmentObject var cart: Cart
    
    var body: some View {
        VStack {
            // Logo image
            Image("enoTransp")
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width * 0.8, height: geometry.size.height / 9)
            
            // HStack positioned below the logo
            HStack {
                Spacer()
                if showChevron {
                    Button(action: {
                        onBack?() // Call the back action
                    }) {
                        Image(systemName: "chevron.left") // Chevron left icon
                            .foregroundColor(.white) // Sets the color to white
                            .font(.system(size: 24))
                    }
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 24, height: 24)
                }
                
                Spacer()
                Rectangle()
                    .fill(Color.white)
                    .frame(width: geometry.size.width * 0.6, height: 2)
                Spacer()
                if showCart {
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
                    } else {
                        NavigationLink(destination: CartContentView(title: "Cart", imageNames: []).environmentObject(cart)) {
                            Image(systemName: "cart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 27, height: 27)
                                .foregroundColor(.white)
                        }
                    }
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 27, height: 27)
                }
                Spacer()
            }
        }
        .background(Color.clear.edgesIgnoringSafeArea(.all))
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            HeaderView(geometry: geometry, showChevron: true, showCart: true, onBack: {})
                .environmentObject(Cart())
        }
    }
}
