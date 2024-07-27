import SwiftUI

struct Checkout: View {
    let title = """
Check out
"""
    @EnvironmentObject var cart: Cart // Access Cart instance from environment
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // Environment variable to handle presentation mode
    let imageNames: [String] // Names of the images in the gallery
    var onBack: (() -> Void)? // Closure for back button action

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
                        presentationMode.wrappedValue.dismiss()
                    })
                    .position(x: geometry.size.width / 2)
                    .padding(.top, 50)
                    Text(title)
                        .font(Font.custom("Papyrus", size: 30))
                        .foregroundColor(.white)
                        .padding(.bottom, 0)
                    SocialMediaLinks()
                    
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))  // Add black background
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true) // Hide the navigation bar
    }
}

struct Checkout_Previews: PreviewProvider {
    static var previews: some View {
        Checkout(imageNames: [""])
            .environmentObject(Cart())
            .previewDisplayName("Checkout View")
    }
}
