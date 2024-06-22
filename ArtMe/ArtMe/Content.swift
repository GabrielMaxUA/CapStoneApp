import SwiftUI

struct ContentView: View {
    // Text constants
    let mainText: String = """
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
    
    Please chose the art genre below
    """
    
    let natureText = "Nature"
    let modelsText = "Models"
    let architectureText = "Architecture"

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Background image
                    Image("mainBack") // Replace with your image name
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width * 1.5, height: geometry.size.height * 1.5)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        .edgesIgnoringSafeArea(.all)
                    
                    ScrollView(.vertical) {
                        VStack {
                            // Logo image
                            Image("enoTransp")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 100.0)
                            
                            // Separator line
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: geometry.size.width * 0.8, height: 2)
                                .padding(.bottom, 45.0)
                            
                            // Main text
                            Text(mainText)
                                .font(Font.custom("Papyrus", size: 20))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            // Separator line
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: geometry.size.width * 0.9, height: 2)
                                .padding(.bottom, 70)
                            
                            // Nature Section
                            navigationLinkSection(imageName: "nature", text: natureText, destination: GalleryView(title: natureText))
                            
                            // Architecture Section
                            navigationLinkSection(imageName: "italy", text: architectureText, destination: GalleryView(title: architectureText))
                            
                            // Models Section
                            navigationLinkSection(imageName: "models", text: modelsText, destination: GalleryView(title: modelsText))
                            
                            // Separator line
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: geometry.size.width * 0.9, height: 2)
                                .padding()
                            
                            // Social media links
                            socialMediaLinks()
                        }
                    }
                    .padding(.bottom, 15)
                    .padding(.top, 50)
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    // Helper function to create a navigation link section
    private func navigationLinkSection(imageName: String, text: String, destination: GalleryView) -> some View {
        NavigationLink(destination: destination) {
            VStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 280, height: 280)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white, lineWidth: 3)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding()
                
                Text(text)
                    .font(Font.custom("Papyrus", size: 25))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // Helper function to create social media links section
    private func socialMediaLinks() -> some View {
        Rectangle()
            .fill(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.2))
            .frame(width: 300, height: 60)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white, lineWidth: 1)
            )
            .cornerRadius(12.0)
            .overlay(
                HStack(spacing: 10) {
                    socialMediaIcon(imageName: "facebook", paddingLeading: -5, paddingTrailing: 40)
                    socialMediaIcon(imageName: "viber", paddingLeading: 10)
                    socialMediaIcon(imageName: "instagram", paddingLeading: 50)
                }
                .padding()
            )
    }
    
    // Helper function to create a social media icon
    private func socialMediaIcon(imageName: String, paddingLeading: CGFloat = 0, paddingTrailing: CGFloat = 0) -> some View {
        Image(imageName) // Replace with your image name
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.leading, paddingLeading)
            .padding(.trailing, paddingTrailing)
    }
}

struct GalleryView: View {
    let title: String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                
                ScrollView(.vertical) {
                    VStack {
                        // Logo image
                        Image("enoTransp")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 100.0)
                            .padding(.top, 50)
                        
                        // Separator line
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: geometry.size.width * 0.8, height: 2)
                            .padding(.bottom, 45.0)
                        
                        // Gallery title
                        Text(title)
                            .font(Font.custom("Papyrus", size: 30))
                            .padding()
                        
                        // Display appropriate gallery based on title
                        if title == "Nature" {
                            natureGallery()
                        } else if title == "Architecture" {
                            architectureGallery()
                        } else if title == "Models" {
                            modelsGallery()
                        }

                        Spacer()
                    }
                }
                
                // Back button
                VStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("")
                            }
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                        }
                        .padding()
                        .background(Color.black.opacity(0))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(x: -170, y: 35)
                    }
                    Spacer()
                }
                .padding(.bottom, 15)
                .padding(.top, 50)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true)
    }
    
    // Gallery views for Nature, Architecture, and Models
    @ViewBuilder
    private func natureGallery() -> some View {
        galleryGrid(imageNames: ["Npic1", "Npic2", "Npic3", "Npic4", "Npic5", "Npic6", "Npic7", "Npic8", "Npic9", "Npic10"])
    }
    
    @ViewBuilder
    private func architectureGallery() -> some View {
        galleryGrid(imageNames: ["Apic1", "Apic2", "Apic3", "Apic4", "Apic5", "Apic6", "Apic7", "Apic8", "Apic9", "Apic10"])
    }
    
    @ViewBuilder
    private func modelsGallery() -> some View {
        galleryGrid(imageNames: ["Mpic1", "Mpic2", "Mpic3", "Mpic4", "Mpic5", "Mpic6", "Mpic7", "Mpic8", "Mpic9", "Mpic10"])
    }
    
    // Helper function to create a grid of images
    private func galleryGrid(imageNames: [String]) -> some View {
        VStack {
            ForEach(0..<imageNames.count / 2) { rowIndex in
                HStack {
                    imageView(name: imageNames[rowIndex * 2])
                    imageView(name: imageNames[rowIndex * 2 + 1])
                }
            }
        }
    }
    
    // Helper function to create an image view
    private func imageView(name: String) -> some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 160, height: 160)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white, lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
