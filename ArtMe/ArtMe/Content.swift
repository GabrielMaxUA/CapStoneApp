import SwiftUI


 //ContentView is the main view of the app
struct ContentView: View {
    // Text constants
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
    
    let mainTextL: String = """
    Welcome to the unique world of art and perspective.
    By choosing the heart piece of your choice you will
    become the only person in the world who owns
    it.
    Please enjoy the help and options provided by
    us to chose the perfect photo of your own taste
    so as view it in real like time in Your own place.
    
    We also help you to find the closest to You high quality
    printshop to make sure Your desire is fully satisfied.
    
    Please chose the art genre below
    """
    let natureText = "Nature"
    let modelsText = "Models"
    let architectureText = "Architecture"
    
    @State private var scrollViewID = UUID() // Unique identifier for ScrollView

    var body: some View {
        NavigationView { // Provides navigation capabilities
            GeometryReader { geometry in // GeometryReader to get the size of the parent container
                if UIDevice.current.orientation.isPortrait{
                    ZStack{ // ZStack to overlay views
                        // Background image
                        Image("mainBack") // Replace with your image name
                            .resizable() // Makes the image resizable
                            .scaledToFill() // Scales the image to fill the container
                            .frame(width: geometry.size.width * 1.5, height: geometry.size.height * 1.5) // Sets the frame of the image
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Positions the image in the center
                            .edgesIgnoringSafeArea(.all) // Makes the image ignore safe area edges
                        
                        VStack { // Vertical stack for logo, text, and other content
                            // Logo image
                                Image("enoTransp") // Replace with your image name
                                    .resizable() // Makes the image resizable
                                    .aspectRatio(contentMode: .fit) // Maintains aspect ratio
                                    .frame(width: 300, height: 100.0) // Sets the frame of the logo image
                                
                                // Separator line
                                Rectangle() // Rectangle shape
                                    .fill(Color.white) // Fills the rectangle with white color
                                    .frame(width: geometry.size.width * 0.8, height: 2) // Sets the frame of the rectangle
                          
                            ScrollViewReader { proxy in // Allows programmatic scrolling
                                ScrollView(.vertical) { // Vertical scroll view
                                    VStack { // Vertical stack for main text and navigation links
                                        // Main text
                                        Text(mainTextP) // Displays the main text
                                            .font(Font.custom("Papyrus", size: 20)) // Sets custom font and size
                                            .foregroundColor(.white) // Sets text color to white
                                            .multilineTextAlignment(.center) // Centers the text
                                            .id(scrollViewID) // Assigns an ID to the top of the content

                                        // Separator line
                                        Rectangle() // Rectangle shape
                                            .fill(Color.white) // Fills the rectangle with white color
                                            .frame(width: geometry.size.width * 0.9, height: 2) // Sets the frame of the rectangle
                                            .padding(.bottom, 70) // Adds bottom padding

                                        // Nature Section
                                        navigationLinkSection(imageName: "nature", text: natureText, destination: GalleryView(title: natureText, imageNames: ["Npic1", "Npic2", "Npic3", "Npic4", "Npic5", "Npic6", "Npic7", "Npic8", "Npic9", "Npic10", "Npic11", "Npic13", "Npic12", "Npic14"], scrollToTop: {
                                            withAnimation { // Scrolls to the top with animation
                                                proxy.scrollTo(scrollViewID, anchor: .top) // Scrolls to the top of the content
                                            }
                                        }))

                                        // Architecture Section
                                        navigationLinkSection(imageName: "italy", text: architectureText, destination: GalleryView(title: architectureText, imageNames: ["Apic1", "Apic2", "Apic3", "Apic4", "Apic5", "Apic6", "Apic7", "Apic8", "Apic9", "Apic10"], scrollToTop: {
                                            withAnimation { // Scrolls to the top with animation
                                                proxy.scrollTo(scrollViewID, anchor: .top) // Scrolls to the top of the content
                                            }
                                        }))

                                        // Models Section
                                        navigationLinkSection(imageName: "models", text: modelsText, destination: GalleryView(title: modelsText, imageNames: ["Mpic1", "Mpic2", "Mpic3", "Mpic4", "Mpic5", "Mpic6", "Mpic7", "Mpic8", "Mpic9", "Mpic10", "Mpic11", "Mpic12", "Mpic13", "Mpic14"], scrollToTop: {
                                            withAnimation { // Scrolls to the top with animation
                                                proxy.scrollTo(scrollViewID, anchor: .top) // Scrolls to the top of the content
                                            }
                                        }))

                                        // Separator line
                                        Rectangle() // Rectangle shape
                                            .fill(Color.white) // Fills the rectangle with white color
                                            .frame(width: geometry.size.width * 0.9, height: 2) // Sets the frame of the rectangle
                                            .padding() // Adds padding

                                        // Social media links
                                        socialMediaLinks() // Displays social media links
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 15) // Adds bottom padding
                        .padding(.top, 50) // Adds top padding
                    }
                    .edgesIgnoringSafeArea(.all) // Makes the ZStack ignore safe area edges
                }
                else {
                    ZStack{ // ZStack to overlay views
                        // Background image
                        Image("mainBack") // Replace with your image name
                            .resizable() // Makes the image resizable
                            .scaledToFill() // Scales the image to fill the container
                            .frame(width: geometry.size.width * 1.6, height: geometry.size.height * 1.5) // Sets the frame of the image
                            .position(x: geometry.size.width / 1.6, y: geometry.size.height / 0.58) // Positions the image in the center
                            .edgesIgnoringSafeArea(.all) // Makes the image ignore safe area edges
                        
                        VStack { // Vertical stack for logo, text, and other content
                            // Logo image
                                Image("enoTransp") // Replace with your image name
                                    .resizable() // Makes the image resizable
                                    .aspectRatio(contentMode: .fit) // Maintains aspect ratio
                                    .frame(width: 300, height: 60.0) // Sets the frame of the logo image
                                    
                                // Separator line
                                Rectangle() // Rectangle shape
                                    .fill(Color.white) // Fills the rectangle with white color
                                    .frame(width: geometry.size.width * 0.8, height: 2) // Sets the frame of the rectangle
                            }
                        .padding(.top, -190)
                            
                            ScrollViewReader { proxy in // Allows programmatic scrolling
                                ScrollView(.vertical) { // Vertical scroll view
                                    VStack { // Vertical stack for main text and navigation links
                                        // Main text
                                        Text(mainTextL) // Displays the main text
                                            .font(Font.custom("Papyrus", size: 20)) // Sets custom font and size
                                            .foregroundColor(.white) // Sets text color to white
                                            .multilineTextAlignment(.center) // Centers the text
                                            .id(scrollViewID) // Assigns an ID to the top of the content
                                            .padding(.top, 40)

                                        // Separator line
                                        Rectangle() // Rectangle shape
                                            .fill(Color.white) // Fills the rectangle with white color
                                            .frame(width: geometry.size.width * 0.9, height: 2) // Sets the frame of the rectangle
                                            .padding(.bottom, 70) // Adds bottom padding
                                        HStack{
                                            navigationLinkSection(imageName: "nature", text: natureText, destination: GalleryView(title: natureText, imageNames: ["Npic1", "Npic2", "Npic3", "Npic4", "Npic5", "Npic6", "Npic7", "Npic8", "Npic9", "Npic10", "Npic11", "Npic13", "Npic12", "Npic14"], scrollToTop: {
                                                withAnimation { // Scrolls to the top with animation
                                                    proxy.scrollTo(scrollViewID, anchor: .top) // Scrolls to the top of the content
                                                }
                                            }))

                                            // Architecture Section
                                            navigationLinkSection(imageName: "italy", text: architectureText, destination: GalleryView(title: architectureText, imageNames: ["Apic1", "Apic2", "Apic3", "Apic4", "Apic5", "Apic6", "Apic7", "Apic8", "Apic9", "Apic10"], scrollToTop: {
                                                withAnimation { // Scrolls to the top with animation
                                                    proxy.scrollTo(scrollViewID, anchor: .top) // Scrolls to the top of the content
                                                }
                                            }))

                                            // Models Section
                                            navigationLinkSection(imageName: "models", text: modelsText, destination: GalleryView(title: modelsText, imageNames: ["Mpic1", "Mpic2", "Mpic3", "Mpic4", "Mpic5", "Mpic6", "Mpic7", "Mpic8", "Mpic9", "Mpic10", "Mpic11", "Mpic12", "Mpic13", "Mpic14"], scrollToTop: {
                                                withAnimation { // Scrolls to the top with animation
                                                    proxy.scrollTo(scrollViewID, anchor: .top) // Scrolls to the top of the content
                                                }
                                            }))
                                        }
                                        // Nature Section
                                        

                                        // Separator line
                                        Rectangle() // Rectangle shape
                                            .fill(Color.white) // Fills the rectangle with white color
                                            .frame(width: geometry.size.width * 0.9, height: 2) // Sets the frame of the rectangle
                                            .padding() // Adds padding

                                        // Social media links
                                        socialMediaLinks() // Displays social media links
                                    }
                                }
                            }
                            .padding(.top, 40)
                        }
                        .padding(.bottom, 15) // Adds bottom padding
                        .padding(.top, 50) // Adds top padding
                    }
                
                }
            }
        }
    }
    
    // Helper function to create a navigation link section
    private func navigationLinkSection(imageName: String, text: String, destination: GalleryView) -> some View {
        NavigationLink(destination: destination) { // Creates a navigation link to the destination view
            if UIDevice.current.orientation.isPortrait{
                VStack { // Vertical stack for image and text
                    Image(imageName) // Displays the image
                        .resizable() // Makes the image resizable
                        .aspectRatio(contentMode: .fit) // Maintains aspect ratio
                        .frame(width: 280, height: 280) // Sets the frame of the image
                        .overlay( // Adds an overlay to the image
                            RoundedRectangle(cornerRadius: 14) // Creates a rounded rectangle
                                .stroke(Color.white, lineWidth: 3) // Strokes the rectangle with white color and 3-point width
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14)) // Clips the image to a rounded rectangle shape
                        .padding() // Adds padding around the image
                    
                    Text(text) // Displays the text
                        .font(Font.custom("Papyrus", size: 25)) // Sets custom font and size
                        .foregroundColor(.white) // Sets text color to white
                        .multilineTextAlignment(.center) // Centers the text
                }
            }
            else {
                VStack { // Vertical stack for image and text
                    Image(imageName) // Displays the image
                        .resizable() // Makes the image resizable
                        .aspectRatio(contentMode: .fit) // Maintains aspect ratio
                        .frame(width: 180, height: 180) // Sets the frame of the image
                        .overlay( // Adds an overlay to the image
                            RoundedRectangle(cornerRadius: 14) // Creates a rounded rectangle
                                .stroke(Color.white, lineWidth: 3) // Strokes the rectangle with white color and 3-point width
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14)) // Clips the image to a rounded rectangle shape
                        .padding() // Adds padding around the image
                    
                    Text(text) // Displays the text
                        .font(Font.custom("Papyrus", size: 25)) // Sets custom font and size
                        .foregroundColor(.white) // Sets text color to white
                        .multilineTextAlignment(.center) // Centers the text
                }
            }
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


// GalleryView to display the gallery images
struct GalleryView: View {
    let title: String // Title of the gallery
    let imageNames: [String] // Names of the images in the gallery
    
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
                if UIDevice.current.orientation.isPortrait { // Checks if the device is in portrait mode
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
                } 
                else { // If the device is in landscape mode
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
                            .offset(x: -geometry.size.width * 0.45, y: 40) // Adjusts the position of the back button
                        }
                        Spacer() // Adds a spacer
                    }
                    .padding(.bottom, 15) // Adds bottom padding
                    .padding(.trailing, 15) // Adds trailing padding
                    .padding(.leading, 15) // Adds leading padding
                    .padding(.top, 10) // Adds top padding
                }
                
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
        if UIDevice.current.orientation.isLandscape{
            Image(imageName) // Displays the background image
                .resizable() // Makes the image resizable
                .scaledToFill() // Scales the image to fill the container
                .frame(
                    width: geometry.size.width * (imageName == "nature" ? 1.3 : imageName == "italy" ? 1.8 : imageName == "models" ? 1.6 : 2),
                    height: geometry.size.height * (imageName == "nature" ? 1.3 : imageName == "italy" ? 1.3 : imageName == "models" ? 1.8 : 2)
                ) // Sets the frame of the image based on the image name
                .position(
                    x: geometry.size.width / (imageName == "nature" ? 2 : imageName == "italy" ? 1.7 : imageName == "models" ? 1.3 : 1.45),
                    y: geometry.size.height / (imageName == "nature" ? 1.5 : imageName == "italy" ? 0.9 : imageName == "models" ? 0.9 : 1.45)
                ) // Positions the image based on the image name
                .edgesIgnoringSafeArea(.all)
        }
        else {
            Image(imageName) // Displays the background image
                .resizable() // Makes the image resizable
                .scaledToFill() // Scales the image to fill the container
                .frame(
                    width: geometry.size.width * (imageName == "nature" ? 2 : imageName == "italy" ? 1.8 : imageName == "models" ? 2 : 2),
                    height: geometry.size.height * (imageName == "nature" ? 1.9 : imageName == "italy" ? 2 : imageName == "models" ? 2 : 2)
                ) // Sets the frame of the image based on the image name
                .position(
                    x: geometry.size.width / (imageName == "nature" ? 2 : imageName == "italy" ? 1.7 : imageName == "models" ? 1.3 : 1.45),
                    y: geometry.size.height / (imageName == "nature" ? 1.5 : imageName == "italy" ? 1 : imageName == "models" ? 1.3 : 1.45)
                ) // Positions the image based on the image name
                .edgesIgnoringSafeArea(.all)
        }
        // Makes the image ignore safe area edges
    }

    
    private func contentView<Content: View>(geometry: GeometryProxy, @ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(spacing: 0) { // Vertical stack for content with no spacing
            // Fixed Logo image
            if UIDevice.current.orientation.isPortrait { // Checks if the device is in portrait mode
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
            } else { // If the device is in landscape mode
                Image("enoTransp") // Displays the logo image
                    .resizable() // Makes the image resizable
                    .aspectRatio(contentMode: .fit) // Maintains aspect ratio
                    .frame(width: 300, height: 60.0) // Sets the frame of the image
                
                // Fixed Separator line
                Rectangle() // Rectangle shape
                    .fill(Color.white) // Fills the rectangle with white color
                    .frame(width: geometry.size.width * 0.8, height: 2) // Sets the frame of the rectangle
                    .padding(.bottom, 5) // Adds bottom padding
                    .padding(.top, 8) // Adds top padding
            }
          
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
    }
   
    private func fullScreenImageView(imageName: String, geometry: GeometryProxy) -> some View {
        ZStack { // ZStack to overlay views
            Color.black.edgesIgnoringSafeArea(.all) // Black background color ignoring safe area edges
            Image(imageName) // Displays the image
                .resizable() // Makes the image resizable
                .scaledToFit() // Scales the image to fit the container
                .offset(x: offset.width, y: offset.height) // Applies offset to the image
                .scaleEffect(scale) // Applies scale effect to the image
                .gesture( // Adds gesture recognizers to the image
                    DragGesture() // Drag gesture
                        .onChanged { value in // Handles drag gesture changes
                            let translation = CGSize(width: value.translation.width * 0.3, height: value.translation.height * 0.3) // Calculates translation with reduced sensitivity
                            let newOffset = CGSize(width: lastOffset.width + translation.width, height: lastOffset.height + translation.height) // Calculates new offset

                            // Calculate the maximum allowed offsets to keep the image within the screen bounds
                            let maxOffsetX = (scale * geometry.size.width - geometry.size.width) / 2 // Maximum horizontal offset
                            let maxOffsetY = (scale * geometry.size.height - geometry.size.height) / 2 // Maximum vertical offset

                            // Calculate the edges of the image
                            let imageLeftEdge = -maxOffsetX // Left edge of the image
                            let imageRightEdge = maxOffsetX // Right edge of the image
                            let imageTopEdge = -maxOffsetY // Top edge of the image
                            let imageBottomEdge = maxOffsetY // Bottom edge of the image

                            // Apply the new offset within the bounds
                            offset = CGSize(
                                width: min(max(newOffset.width, imageLeftEdge), imageRightEdge), // Horizontal offset within bounds
                                height: min(max(newOffset.height, imageTopEdge), imageBottomEdge) // Vertical offset within bounds
                            )
                        }
                        .onEnded { _ in // Handles drag gesture end
                            lastOffset = offset // Saves the last offset
                        }
                )
                .gesture( // Adds magnification gesture recognizer to the image
                    MagnificationGesture() // Magnification gesture
                        .onChanged { value in // Handles magnification gesture changes
                            scale = lastScale * value.magnitude // Adjusts the scale based on the magnification gesture
                        }
                        .onEnded { value in // Handles magnification gesture end
                            lastScale = scale // Saves the last scale
                        }
                )
                .gesture( // Adds double tap gesture recognizer to the image
                    TapGesture(count: 2) // Double tap gesture
                        .onEnded {
                            if scale > 1 { // Checks if the scale is greater than 1
                                scale = 1 // Resets the scale to 1
                                lastScale = 1 // Resets the last scale to 1
                                offset = .zero // Resets the offset to zero
                                lastOffset = .zero // Resets the last offset to zero
                            } else { // If the scale is 1 or less
                                scale = 5 // Sets the scale to 5
                            }
                        }
                )
                .gesture( // Adds single tap gesture recognizer to the image
                    TapGesture(count: 1) // Single tap gesture
                        .onEnded {
                            withAnimation { // Toggles cross button visibility with animation
                                showCrossButton.toggle() // Toggles cross button visibility
                            }
                        }
                )
                .gesture( // Adds swipe gesture recognizer to the image
                    DragGesture(minimumDistance: 50) // Drag gesture with minimum distance
                        .onEnded { value in // Handles drag gesture end
                            if value.translation.width < 0 { // Checks if swiped left
                                if selectedImageIndex < imageNames.count - 1 { // Checks if not the last image
                                    selectedImageIndex += 1 // Increments the selected image index
                                }
                            } else if value.translation.width > 0 { // Checks if swiped right
                                if selectedImageIndex > 0 { // Checks if not the first image
                                    selectedImageIndex -= 1 // Decrements the selected image index
                                }
                            }
                        }
                )
            if showCrossButton { // Checks if cross button should be visible
                GeometryReader { geo in // GeometryReader to get the size of the parent container
                    VStack { // Vertical stack for cross button and navigation buttons
                        Button(action: { // Cross button action
                            self.showFullScreen = false // Disables full-screen view
                            self.scale = 1.0 // Resets the scale to 1
                            self.lastScale = 1.0 // Resets the last scale to 1
                            self.offset = .zero // Resets the offset to zero
                            self.lastOffset = .zero // Resets the last offset to zero
                        }) {
                            Image(systemName: "xmark") // Cross icon
                                .foregroundColor(.white) // Sets the color to white
                                .font(.system(size: 34)) // Sets the font size to 34
                                .padding() // Adds padding around the icon
                        }
                        .padding(.top, UIDevice.current.orientation.isPortrait ? 20 : -10) // Adds top padding based on device orientation
                        .padding(.leading, UIDevice.current.orientation.isPortrait ? 20 : 0) // Adds leading padding based on device orientation
                        .frame(width: geo.size.width, height: geo.size.height) // Sets the frame of the button
                        .position(x: geo.size.width - 50, y: 50) // Positions the button
                        
                        Spacer() // Adds a spacer
                        
                        HStack { // Horizontal stack for navigation buttons
                            if selectedImageIndex > 0 { // Checks if not the first image
                                Button(action: {
                                    if selectedImageIndex > 0 { // Checks if not the first image
                                        selectedImageIndex -= 1 // Decrements the selected image index
                                    }
                                }) {
                                    Image(systemName: "chevron.left") // Chevron left icon
                                        .foregroundColor(.white) // Sets the color to white
                                        .font(.system(size: 34)) // Sets the font size to 34
                                        .padding() // Adds padding around the icon
                                        .padding(.leading, UIDevice.current.orientation.isLandscape ? 40 : 0) // Adds leading padding based on device orientation
                                }
                                
                            }
                            Spacer() // Adds a spacer
                            if selectedImageIndex < imageNames.count - 1 { // Checks if not the last image
                                Button(action: {
                                    if selectedImageIndex < imageNames.count - 1 { // Checks if not the last image
                                        selectedImageIndex += 1 // Increments the selected image index
                                    }
                                }) {
                                    Image(systemName: "chevron.right") // Chevron right icon
                                        .foregroundColor(.white) // Sets the color to white
                                        .font(.system(size: 34)) // Sets the font size to 34
                                        .padding() // Adds padding around the icon
                                }
                            }
                        }
                        .frame(width: geo.size.width, height: geo.size.height) // Sets the frame of the navigation buttons
                        .padding(.horizontal, 0) // Adds horizontal padding
                    }
                }
            }
            Spacer() // Adds a spacer
        }
        .edgesIgnoringSafeArea(.all) // Makes the ZStack ignore safe area edges
        .navigationBarHidden(true) // Hides the navigation bar
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
            if UIDevice.current.orientation.isPortrait { // Checks if the device is in portrait mode
                ForEach(0..<(imageNames.count + 1) / 2, id: \.self) { rowIndex in // Iterates over the rows
                    HStack { // Horizontal stack for images
                        imageView(name: imageNames[rowIndex * 2]) // Displays the first image in the row
                        if rowIndex * 2 + 1 < imageNames.count { // Checks if there is a second image in the row
                            imageView(name: imageNames[rowIndex * 2 + 1]) // Displays the second image in the row
                        }
                    }
                }
            } else { // If the device is in landscape mode
                ForEach(0..<(imageNames.count + 2) / 3, id: \.self) { rowIndex in // Iterates over the rows
                    HStack { // Horizontal stack for images
                        Spacer() // Adds a spacer
                        imageView(name: imageNames[rowIndex * 3]) // Displays the first image in the row
                        if rowIndex * 3 + 1 < imageNames.count { // Checks if there is a second image in the row
                            imageView(name: imageNames[rowIndex * 3 + 1]) // Displays the second image in the row
                        }
                        if rowIndex * 3 + 2 < imageNames.count { // Checks if there is a third image in the row
                            imageView(name: imageNames[rowIndex * 3 + 2]) // Displays the third image in the row
                        }
                        Spacer() // Adds a spacer
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

// Preview provider for ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDisplayName("Portrait")
            
            ContentView()
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("Landscape")
        }
    }
}
