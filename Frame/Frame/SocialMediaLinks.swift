//
//  SocialMediaLinks.swift
//  Frame
//
//  Created by Max Gabriel on 2024-07-20.
//

import SwiftUI

struct SocialMediaLinks: View {
    var body: some View {
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
                  /*  .background(Color.blue.edgesIgnoringSafeArea(.all))*/  // Add black background
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

struct SocialMediaLinks_Previews: PreviewProvider {
    static var previews: some View {
        SocialMediaLinks()
    }
}

