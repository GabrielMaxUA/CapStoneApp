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
                        
                        ScrollView(.vertical) {
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
}

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

struct GalleryView: View {
    let title: String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedImage: String? = nil
    @State private var showFullScreen = false
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background and gallery content based on the title
                if title == "Nature" {
                    backgroundView(imageName: "nature", geometry: geometry)
                    contentView(geometry: geometry) {
                        natureGallery()
                    }
                } else if title == "Architecture" {
                    backgroundView(imageName: "italy", geometry: geometry)
                    contentView(geometry: geometry) {
                        architectureGallery()
                    }
                } else if title == "Models" {
                    backgroundView(imageName: "models", geometry: geometry)
                    contentView(geometry: geometry) {
                        modelsGallery()
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
                            .font(.system(size: 34))
                        }
                        .padding(3)
                        .background(Color.white.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(x: -170, y: 90)
                    }
                    Spacer()
                }
                .padding(.bottom, 15)
                .padding(.trailing, 15)
                .padding(.leading, 15)
                .padding(.top, 50)
                
                // Full-screen image view
                if let selectedImage = selectedImage, showFullScreen {
                    fullScreenImageView(imageName: selectedImage, geometry: geometry)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true)
    }
    
    // Helper functions
    private func backgroundView(imageName: String, geometry: GeometryProxy) -> some View {
        Image(imageName) // Replace with your image name
            .resizable()
            .scaledToFill()
            .frame(width: geometry.size.width * (imageName == "nature" ? 1.3 : imageName == "italy" ? 1.8 : 2), height: geometry.size.height * (imageName == "nature" ? 1.3 : imageName == "italy" ? 1.8 : 2))
            .position(x: geometry.size.width / (imageName == "nature" ? 2 : imageName == "italy" ? 1.2 : 1.45), y: geometry.size.height / (imageName == "nature" ? 2 : imageName == "italy" ? 1.2 : 1.45))
            .edgesIgnoringSafeArea(.all)
    }
    
    private func contentView<Content: View>(geometry: GeometryProxy, @ViewBuilder content: @escaping () -> Content) -> some View {
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
                    .padding(.bottom, 5.0)
                
                // Gallery title
                Text(title)
                    .font(Font.custom("Papyrus", size: 30))
                    .foregroundColor(.white)
                
                content()
                
                // Separator line
                Rectangle()
                    .fill(Color.white)
                    .frame(width: geometry.size.width * 0.8, height: 2)
                    .padding(.bottom, 5.0)
                
                socialMediaLinks()
            }
        }
    }
    
    private func fullScreenImageView(imageName: String, geometry: GeometryProxy) -> some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Image(imageName)
                .resizable()
                .scaledToFit()
                .offset(x: offset.width, y: offset.height)
                .scaleEffect(scale)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let translation = CGSize(width: value.translation.width * 0.3, height: value.translation.height * 0.3)
                            let newOffset = CGSize(width: lastOffset.width + translation.width, height: lastOffset.height + translation.height)

                            // Calculate the maximum allowed offsets to keep the image within the screen bounds
                            let maxOffsetX = (scale * geometry.size.width - geometry.size.width) / 2
                            let maxOffsetY = (scale * geometry.size.height - geometry.size.height) / 2

                            // Calculate the edges of the image
                            let imageLeftEdge = -maxOffsetX
                            let imageRightEdge = maxOffsetX
                            let imageTopEdge = -maxOffsetY
                            let imageBottomEdge = maxOffsetY

                            // Apply the new offset within the bounds
                            offset = CGSize(
                                width: min(max(newOffset.width, imageLeftEdge), imageRightEdge),
                                height: min(max(newOffset.height, imageTopEdge), imageBottomEdge)
                            )
                        }
                        .onEnded { _ in
                            // Save the last offset
                            lastOffset = offset
                        }
                )

                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            // Adjust the scale based on the magnification gesture
                            scale = lastScale * value.magnitude
                        }
                        .onEnded { value in
                            // Save the last scale
                            lastScale = scale
                        }
                )
                .gesture(
                    TapGesture(count: 2)
                        .onEnded {
                            // Double tap to reset scale and position
                            if scale > 1 {
                                scale = 1
                                lastScale = 1
                                offset = .zero
                                lastOffset = .zero
                            } else {
                                scale = 5
                            }
                        }
                )
            VStack {
                     HStack {
                         Spacer()
                         Button(action: {
                             self.showFullScreen = false
                             self.scale = 1.0
                             self.lastScale = 1.0
                             self.offset = .zero
                             self.lastOffset = .zero
                         }) {
                             Image(systemName: "xmark")
                                 .foregroundColor(.white)
                                 .font(.system(size: 34))
                                 .padding()
                         }
                     }
                     Spacer()
                 }
            .padding(.top, 50)
        }
        .edgesIgnoringSafeArea(.all)
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
            .onTapGesture {
                self.selectedImage = name
                self.showFullScreen = true
                self.scale = 1.0
                self.lastScale = 1.0
                self.offset = .zero
                self.lastOffset = .zero
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
