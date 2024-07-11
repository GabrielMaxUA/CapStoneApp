import SwiftUI

struct ContentView: View {
    let mainTextP: String = """
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
    
    @State private var scrollViewID = UUID() // Unique identifier for ScrollView

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Image("mainBack")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width * 1.5, height: geometry.size.height * 1.5)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Image("enoTransp")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 100.0)
                        
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: geometry.size.width * 0.8, height: 2)
                        
                        ScrollViewReader { proxy in
                            ScrollView(.vertical) {
                                VStack {
                                    Text(mainTextP)
                                        .font(Font.custom("Papyrus", size: 20))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .id(scrollViewID)

                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: geometry.size.width * 0.9, height: 2)
                                        .padding(.bottom, 70)

                                    navigationLinkSection(imageName: "nature", text: natureText, destination: GalleryView(title: natureText, imageNames: ["Npic1", "Npic2", "Npic3", "Npic4", "Npic5", "Npic6", "Npic7", "Npic8", "Npic9", "Npic10", "Npic11", "Npic13", "Npic12", "Npic14"], scrollToTop: {
                                        withAnimation {
                                            proxy.scrollTo(scrollViewID, anchor: .top)
                                        }
                                    }))

                                    navigationLinkSection(imageName: "italy", text: architectureText, destination: GalleryView(title: architectureText, imageNames: ["Apic1", "Apic2", "Apic3", "Apic4", "Apic5", "Apic6", "Apic7", "Apic8", "Apic9", "Apic10"], scrollToTop: {
                                        withAnimation {
                                            proxy.scrollTo(scrollViewID, anchor: .top)
                                        }
                                    }))

                                    navigationLinkSection(imageName: "models", text: modelsText, destination: GalleryView(title: modelsText, imageNames: ["Mpic1", "Mpic2", "Mpic3", "Mpic4", "Mpic5", "Mpic6", "Mpic7", "Mpic8", "Mpic9", "Mpic10", "Mpic11", "Mpic12", "Mpic13", "Mpic14"], scrollToTop: {
                                        withAnimation {
                                            proxy.scrollTo(scrollViewID, anchor: .top)
                                        }
                                    }))

                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: geometry.size.width * 0.9, height: 2)
                                        .padding(.bottom, 5)

                                    socialMediaLinks()
                                        .padding(.bottom, 20)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 15)
                    .padding(.top, 50)
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    let imageName: String
}

class Cart: ObservableObject {
    @Published var items: [CartItem] = []
    
    func addItem(imageName: String) {
        let newItem = CartItem(imageName: imageName)
        items.append(newItem)
    }
}

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

private func socialMediaIcon(imageName: String, paddingLeading: CGFloat = 0, paddingTrailing: CGFloat = 0) -> some View {
    Image(imageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 50, height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.leading, paddingLeading)
        .padding(.trailing, paddingTrailing)
}

// The rest of your Content.swift file...


// GalleryView to display the gallery images
struct GalleryView: View {
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
    let scrollToTop: () -> Void // Callback to scroll to the top of the content
    
    var body: some View {
        GeometryReader { geometry in // GeometryReader to get the size of the parent container
            ZStack { // ZStack to overlay views
                // Background and gallery content based on the title
                if title == "Nature" { // Checks if the title is "Nature"
                    backgroundView(imageName: "nature", geometry: geometry) // Calls backgroundView with "nature" image
                    contentView(geometry: geometry) { // Calls contentView with natureGallery content
                        natureGallery()
                    }
                } else if title == "Architecture" { // Checks if the title is "Architecture"
                    backgroundView(imageName: "italy", geometry: geometry) // Calls backgroundView with "italy" image
                    contentView(geometry: geometry) { // Calls contentView with architectureGallery content
                        architectureGallery()
                    }
                } else if title == "Models" { // Checks if the title is "Models"
                    backgroundView(imageName: "models", geometry: geometry) // Calls backgroundView with "models" image
                    contentView(geometry: geometry) { // Calls contentView with modelsGallery content
                        modelsGallery()
                    }
                }
                
                // Back button
                VStack { // Vertical stack for back button
                    HStack { // Horizontal stack for back button
                        Button(action: { // Back button action
                            self.presentationMode.wrappedValue.dismiss() // Dismisses the view
                            scrollToTop() // Scrolls to the top of the content
                        }) {
                            HStack { // Horizontal stack for back button icon
                                Image(systemName: "chevron.left") // Chevron left icon
                                Text("") // Empty text
                            }
                            .foregroundColor(.white) // Sets the color to white
                            .font(.system(size: 34)) // Sets the font size to 34
                        }
                        .padding(3) // Adds padding around the button
                        .background(Color.white.opacity(0)) // Sets the background color with 0 opacity
                        .clipShape(RoundedRectangle(cornerRadius: 10)) // Clips the button to a rounded rectangle shape
                        .padding(.leading, 20) // Adds leading padding
                        .offset(x: -geometry.size.width * 0.45, y: 90) // Adjusts the position of the back button
                    }
                    Spacer() // Adds a spacer
                }
                .padding(.bottom, 15) // Adds bottom padding
                .padding(.trailing, 15) // Adds trailing padding
                .padding(.leading, 15) // Adds leading padding
                .padding(.top, 50) // Adds top padding
                
                // Full-screen image view
                if showFullScreen { // Checks if full-screen view is enabled
                    fullScreenImageView(imageName: imageNames[selectedImageIndex], geometry: geometry) // Calls fullScreenImageView with the selected image
                }
            }
            .edgesIgnoringSafeArea(.all) // Makes the ZStack ignore safe area edges
        }
        .navigationBarHidden(true) // Hides the navigation bar
    }
    
    // Helper functions
    private func backgroundView(imageName: String, geometry: GeometryProxy) -> some View {
        Image(imageName) // Displays the background image
            .resizable() // Makes the image resizable
            .scaledToFill() // Scales the image to fill the container
            .frame(
                width: geometry.size.width * 2,
                height: geometry.size.height * 1.9
            ) // Sets the frame of the image based on the image name
            .position(
                x: geometry.size.width / 2,
                y: geometry.size.height / 1.5
            ) // Positions the image based on the image name
            .edgesIgnoringSafeArea(.all)
        // Makes the image ignore safe area edges
    }

    private func contentView<Content: View>(geometry: GeometryProxy, @ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(spacing: 0) { // Vertical stack for content with no spacing
            // Fixed Logo image
            Image("enoTransp") // Displays the logo image
                .resizable() // Makes the image resizable
                .aspectRatio(contentMode: .fit) // Maintains aspect ratio
                .frame(width: 300, height: 100.0) // Sets the frame of the image
                .padding(.top, 50) // Adds top padding
            
            // Fixed Separator line
            Rectangle() // Rectangle shape
                .fill(Color.white) // Fills the rectangle with white color
                .frame(width: geometry.size.width * 0.8, height: 2) // Sets the frame of the rectangle
                .padding(.bottom, 5) // Adds bottom padding
                .padding(.top, 8) // Adds top padding
            
            // Gallery title
            HStack { // Horizontal stack for title
                Text(title) // Displays the title
                    .font(Font.custom("Papyrus", size: 30)) // Sets custom font and size
                    .foregroundColor(.white) // Sets text color to white
                    .padding(.bottom, 0) // Adds bottom padding
            }
            
            ScrollView(.vertical) { // Vertical scroll view
                VStack(spacing: 0) { // Vertical stack for gallery content with no spacing
                    content() // Calls the content view builder

                    // Separator line
                    Rectangle() // Rectangle shape
                        .fill(Color.white) // Fills the rectangle with white color
                        .frame(width: geometry.size.width * 0.8, height: 2) // Sets the frame of the rectangle
                        .padding(.bottom, 5.0) // Adds bottom padding

                    socialMediaLinks() // Displays social media links
                }
            }
        }
        .padding(.bottom, 15)
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

                            let maxOffsetX = (scale * geometry.size.width - geometry.size.width) / 2
                            let maxOffsetY = (scale * geometry.size.height - geometry.size.height) / 2

                            let imageLeftEdge = -maxOffsetX
                            let imageRightEdge = maxOffsetX
                            let imageTopEdge = -maxOffsetY
                            let imageBottomEdge = maxOffsetY

                            offset = CGSize(
                                width: min(max(newOffset.width, imageLeftEdge), imageRightEdge),
                                height: min(max(newOffset.height, imageTopEdge), imageBottomEdge)
                            )
                        }
                        .onEnded { _ in
                            lastOffset = offset
                        }
                )
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
                .gesture(
                    TapGesture(count: 1)
                        .onEnded {
                            withAnimation {
                                showCrossButton.toggle()
                            }
                        }
                )
                .gesture(
                    DragGesture(minimumDistance: 50)
                        .onEnded { value in
                            if value.translation.width < 0 {
                                if selectedImageIndex < imageNames.count - 1 {
                                    selectedImageIndex += 1
                                }
                            } else if value.translation.width > 0 {
                                if selectedImageIndex > 0 {
                                    selectedImageIndex -= 1
                                }
                            }
                        }
                )
            
            GeometryReader { geo in
                VStack {
                    HStack {
                        if !cart.items.isEmpty {
                            ZStack {
                                NavigationLink(destination: CartGalleryView().environmentObject(cart)) {
                                    Image(systemName: "cart")
                                        .foregroundColor(.white)
                                        .font(.system(size: 34))
                                        .padding()
                                }
                                .padding(.top, 20)
                                .padding(.leading, 20)
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 17)
                                    .offset(x: 25, y: -5)
                            }
                        }

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
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                    }
                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                
                if showCrossButton {
                    VStack {
                        Spacer()
                        HStack {
                            if selectedImageIndex > 0 {
                                Button(action: {
                                    if selectedImageIndex > 0 {
                                        selectedImageIndex -= 1
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
                            Button(action: {
                                cart.addItem(imageName: imageName)
                            }) {
                                Text("Add to Cart")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .padding()
                                    .background(Color.gray)
                                    .cornerRadius(10)
                            }
                            Button(action: {
                                // Try it On action
                            }) {
                                Text("Try it On")
                                    .foregroundColor(.white)
                                    .font(.system(size: 17))
                                    .padding()
                                    .background(Color.gray)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.bottom, 40)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }

    
    // Gallery views for Nature, Architecture, and Models
    @ViewBuilder
    private func natureGallery() -> some View {
        galleryGrid(imageNames: imageNames) // Calls galleryGrid with image names
    }
    
    @ViewBuilder
    private func architectureGallery() -> some View {
        galleryGrid(imageNames: imageNames) // Calls galleryGrid with image names
    }
    
    @ViewBuilder
    private func modelsGallery() -> some View {
        galleryGrid(imageNames: imageNames) // Calls galleryGrid with image names
    }
    
    // Helper function to create a grid of images
    private func galleryGrid(imageNames: [String]) -> some View {
        VStack { // Vertical stack for image grid
            ForEach(0..<(imageNames.count + 1) / 2, id: \.self) { rowIndex in // Iterates over the rows
                HStack { // Horizontal stack for images
                    imageView(name: imageNames[rowIndex * 2]) // Displays the first image in the row
                    if rowIndex * 2 + 1 < imageNames.count { // Checks if there is a second image in the row
                        imageView(name: imageNames[rowIndex * 2 + 1]) // Displays the second image in the row
                    }
                }
            }
        }
    }

    // Helper function to create an image view
    private func imageView(name: String) -> some View {
        Image(name) // Displays the image
            .resizable() // Makes the image resizable
            .aspectRatio(contentMode: .fit) // Maintains aspect ratio
            .frame(width: 160) // Sets the frame of the image
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white, lineWidth: 1)) // Adds an overlay with rounded rectangle and stroke
            .clipShape(RoundedRectangle(cornerRadius: 14)) // Clips the image to a rounded rectangle shape
            .padding() // Adds padding around the image
            .onTapGesture { // Adds tap gesture recognizer
                self.selectedImageIndex = imageNames.firstIndex(of: name) ?? 0 // Sets the selected image index
                self.showFullScreen = true // Enables full-screen view
                self.scale = 1.0 // Resets the scale to 1
                self.lastScale = 1.0 // Resets the last scale to 1
                self.offset = .zero // Resets the offset to zero
                self.lastOffset = .zero // Resets the last offset to zero
            }
    }
    
    // Helper function to create social media links section
    private func socialMediaLinks() -> some View {
        Rectangle() // Rectangle shape
            .fill(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.2)) // Fills the rectangle with semi-transparent white color
            .frame(width: 300, height: 60) // Sets the frame of the rectangle
            .overlay( // Adds an overlay to the rectangle
                RoundedRectangle(cornerRadius: 12) // Creates a rounded rectangle
                    .stroke(Color.white, lineWidth: 1) // Strokes the rectangle with white color and 1-point width
            )
            .cornerRadius(12.0) // Sets the corner radius of the rectangle
            .overlay( // Adds another overlay to the rectangle
                HStack(spacing: 10) { // Horizontal stack for social media icons with spacing
                    socialMediaIcon(imageName: "facebook", paddingLeading: -5, paddingTrailing: 40) // Facebook icon
                    socialMediaIcon(imageName: "viber", paddingLeading: 10) // Viber icon
                    socialMediaIcon(imageName: "instagram", paddingLeading: 50) // Instagram icon
                }
                .padding() // Adds padding around the icons
            )
    }
    
    // Helper function to create a social media icon
    private func socialMediaIcon(imageName: String, paddingLeading: CGFloat = 0, paddingTrailing: CGFloat = 0) -> some View {
        Image(imageName) // Displays the icon image
            .resizable() // Makes the image resizable
            .aspectRatio(contentMode: .fit) // Maintains aspect ratio
            .frame(width: 50, height: 50) // Sets the frame of the image
            .clipShape(RoundedRectangle(cornerRadius: 10)) // Clips the image to a rounded rectangle shape
            .padding(.leading, paddingLeading) // Adds leading padding
            .padding(.trailing, paddingTrailing) // Adds trailing padding
    }
  
}

struct CartGalleryView: View {
    @EnvironmentObject var cart: Cart
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
                
                VStack {
                    // Logo and Chevron
                    VStack {
                        HStack {
                            Spacer()
                            Image("enoTransp") // Replace with your image name
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 100.0)
                            Spacer()
                        }
                        
                        HStack {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 34))
                                    .padding(.leading, 20)
                            }
                            
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: geometry.size.width * 0.8, height: 2)
                                .background(Color.blue.opacity(0.5))
                            Spacer() // Add another spacer to balance the content in the center
                        }
                    }
                    .padding(.top, 50)
                    
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            ForEach(0..<(cart.items.count + 1) / 2, id: \.self) { rowIndex in
                                HStack {
                                    Spacer()
                                    ForEach(0..<2) { columnIndex in
                                        let index = rowIndex * 2 + columnIndex
                                        if index < cart.items.count {
                                            imageView(name: cart.items[index].imageName, geometry: geometry)
                                        } else if columnIndex == 0 {
                                            Spacer()
                                                .frame(width: geometry.size.width * 0.35, height: geometry.size.width * 0.35)
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                    }
                    
                    // Separator line
                    Rectangle() // Rectangle shape
                        .fill(Color.white) // Fills the rectangle with white color
                        .frame(width: geometry.size.width * 0.9, height: 2) // Sets the frame of the rectangle
                        .padding(.bottom, 5) // Adds padding
                    // Social media links
                    socialMediaLinks()
                }
                .padding(.bottom, 15) // Adds bottom padding
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true) // Hide the system back button
    }
    
    // Helper function to create an image view
    private func imageView(name: String, geometry: GeometryProxy) -> some View {
        Image(name) // Displays the image
            .resizable() // Makes the image resizable
            .aspectRatio(contentMode: .fit) // Maintains aspect ratio
            .frame(width: geometry.size.width * 0.35) // Sets the frame of the image to 35% of display width
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white, lineWidth: 1)) // Adds an overlay with rounded rectangle and stroke
            .clipShape(RoundedRectangle(cornerRadius: 14)) // Clips the image to a rounded rectangle shape
            .padding() // Adds padding around the image
    }
    
    // Helper function to create social media links section
    private func socialMediaLinks() -> some View {
        Rectangle() // Rectangle shape
            .fill(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.2)) // Fills the rectangle with semi-transparent white color
            .frame(width: 300, height: 60) // Sets the frame of the rectangle
            .overlay( // Adds an overlay to the rectangle
                RoundedRectangle(cornerRadius: 12) // Creates a rounded rectangle
                    .stroke(Color.white, lineWidth: 1) // Strokes the rectangle with white color and 1-point width
            )
            .cornerRadius(12.0) // Sets the corner radius of the rectangle
            .overlay( // Adds another overlay to the rectangle
                HStack(spacing: 10) { // Horizontal stack for social media icons with spacing
                    socialMediaIcon(imageName: "facebook", paddingLeading: -5, paddingTrailing: 40) // Facebook icon
                    socialMediaIcon(imageName: "viber", paddingLeading: 10) // Viber icon
                    socialMediaIcon(imageName: "instagram", paddingLeading: 50) // Instagram icon
                }
                .padding() // Adds padding around the icons
            )
    }
    
    // Helper function to create a social media icon
    private func socialMediaIcon(imageName: String, paddingLeading: CGFloat = 0, paddingTrailing: CGFloat = 0) -> some View {
        Image(imageName) // Displays the icon image
            .resizable() // Makes the image resizable
            .aspectRatio(contentMode: .fit) // Maintains aspect ratio
            .frame(width: 50, height: 50) // Sets the frame of the image
            .clipShape(RoundedRectangle(cornerRadius: 10)) // Clips the image to a rounded rectangle shape
            .padding(.leading, paddingLeading) // Adds leading padding
            .padding(.trailing, paddingTrailing) // Adds trailing padding
    }
}


// Preview provider for ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Cart())
    }
}
