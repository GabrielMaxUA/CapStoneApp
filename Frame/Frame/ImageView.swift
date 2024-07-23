//
//  ImageView.swift
//  Frame
//
//  Created by Max Gabriel on 2024-07-22.
//

import SwiftUI

struct ImageView: View {
    let name: String
    @Binding var selectedImageIndex: Int
    @Binding var showFullScreen: Bool
    @Binding var scale: CGFloat
    @Binding var lastScale: CGFloat
    @Binding var offset: CGSize
    @Binding var lastOffset: CGSize
    let imageNames: [String]

    var body: some View {
        Image(name) // Displays the image
            .resizable() // Makes the image resizable
            .aspectRatio(contentMode: .fit) // Maintains aspect ratio
            .frame(width: 160) // Sets the frame of the image
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white, lineWidth: 1)) // Adds an overlay with rounded rectangle and stroke
            .clipShape(RoundedRectangle(cornerRadius: 14)) // Clips the image to a rounded rectangle shape
            .padding()
            .shadow(color: .white, radius: 5)// Adds padding around the image
            .onTapGesture { // Adds tap gesture recognizer
                self.selectedImageIndex = self.imageNames.firstIndex(of: name) ?? 0 // Sets the selected image index
                self.showFullScreen = true // Enables full-screen view
                self.scale = 1.0 // Resets the scale to 1
                self.lastScale = 1.0 // Resets the last scale to 1
                self.offset = .zero // Resets the offset to zero
                self.lastOffset = .zero // Resets the last offset to zero
            }
    }
}
