import SwiftUI

struct FrameContentView: View {
    let maintext = """
    Welcome to the unique world
    of art and perspective.
    By choosing the heart piece
    of your choice you will
    become the only person
    In the world who owns
    It. Please enjoy the help
    and options provided by
    us to chose the perfect
    photo of your own taste
    so as view it in real like
    time in your own place.
    
    We also help you to find
    the closest to You high quality
    printshop to make sure
    Your desire is fully satisfied.
    
    Please chose the art genre 
    below
"""
    let natureText = "Nature"
    let modelsText = "Models"
    let architectureText = "Architecture"
    @State private var scrollViewID = UUID()
    
    @EnvironmentObject var cart: Cart
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                // Background image
                Image("mainBack")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 1.5, height: geometry.size.height * 1.5)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .edgesIgnoringSafeArea(.all)
                ZStack {
                    VStack {
                        HeaderView(geometry: geometry, showChevron: false, showCart: true, onBack: nil)
                            .padding(.top, -55)
                        ScrollViewReader { proxy in
                            ScrollView(.vertical) {
                                VStack {
                                    Text(maintext)
                                        .font(Font.custom("Papyrus", size: 20))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .id(scrollViewID)

                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: geometry.size.width * 0.6, height: 2)
                                        .padding(.bottom, 70)
                                    Spacer()
                                    navigationLinkSection(imageName: "nature", text: natureText, destination: GalleryView(title: natureText, imageNames: ["Npic1", "Npic2", "Npic3", "Npic4", "Npic5", "Npic6", "Npic7", "Npic8", "Npic9", "Npic10", "Npic11", "Npic13", "Npic12", "Npic14"]).environmentObject(cart))
                                    Spacer()
                                    navigationLinkSection(imageName: "italy", text: architectureText, destination: GalleryView(title: architectureText, imageNames: ["Apic1", "Apic2", "Apic3", "Apic4", "Apic5", "Apic6", "Apic7", "Apic8", "Apic9", "Apic10"]).environmentObject(cart))
                                    Spacer()
                                    navigationLinkSection(imageName: "models", text: modelsText, destination:GalleryView(title: modelsText, imageNames: ["Mpic1", "Mpic2", "Mpic3", "Mpic4", "Mpic5", "Mpic6", "Mpic7", "Mpic8", "Mpic9", "Mpic10", "Mpic11", "Mpic12", "Mpic13", "Mpic14"]).environmentObject(cart))
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: geometry.size.width * 0.6, height: 2)
                                        .padding(.bottom, 5)
                                        .padding(.top, 20)
                                    SocialMediaLinks()
                                        .padding(.bottom, -14)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 50)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))  // Add black background
        }
    }

    struct YourApp: App {
        @StateObject private var cart = Cart()

        var body: some Scene {
            WindowGroup {
                FrameContentView()
                    .environmentObject(cart)
            }
        }
    }

    private func navigationLinkSection<Destination: View>(imageName: String, text: String, destination: Destination) -> some View {
        NavigationLink(destination: destination) {
            VStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 280, height: 280)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white, lineWidth: 1)
                            
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: .white, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .padding()
                
                
                Text(text)
                    .font(Font.custom("Papyrus", size: 25))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct FrameContentView_Previews: PreviewProvider {
    static var previews: some View {
        let cart = Cart()
        cart.addItem(imageName: "Npic1")
        cart.addItem(imageName: "Npic2")
        cart.addItem(imageName: "Npic3")

        return Group {
            FrameContentView()
                .environmentObject(cart)
                .previewDisplayName("Frame Content View")
            
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
            .previewDisplayName("Architecture Gallery")
            
            GeometryReader { geometry in
                HeaderView(geometry: geometry, showChevron: true, showCart: true, onBack: {})
                    .environmentObject(Cart())
            }
            .previewDisplayName("Header View")
            
            CartContentView(title: "Cart", imageNames: ["Npic1", "Npic2", "Npic3"])
                .environmentObject(Cart())
                .previewDisplayName("Cart Content View")
            
            Checkout(imageNames: [""])
                .environmentObject(cart)
                .previewDisplayName("Checkout View")
        }
    }
}

