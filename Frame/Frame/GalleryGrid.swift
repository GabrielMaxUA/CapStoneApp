//
//  GalleryGrid.swift
//  Frame
//
//  Created by Max Gabriel on 2024-07-22.
//

import SwiftUI

struct GalleryGrid: View {
    let imageNames: [String]
    @Binding var selectedImageIndex: Int
    @Binding var showFullScreen: Bool
    @Binding var scale: CGFloat
    @Binding var lastScale: CGFloat
    @Binding var offset: CGSize
    @Binding var lastOffset: CGSize
    @EnvironmentObject var cart: Cart

    var body: some View {
        VStack { // Vertical stack for image grid
            ForEach(0..<(imageNames.count + 1) / 2, id: \.self) { rowIndex in // Iterates over the rows
                HStack { // Horizontal stack for images
                    ImageView(
                        name: imageNames[rowIndex * 2],
                        selectedImageIndex: $selectedImageIndex,
                        showFullScreen: $showFullScreen,
                        scale: $scale,
                        lastScale: $lastScale,
                        offset: $offset,
                        lastOffset: $lastOffset,
                        imageNames: imageNames
                    )
                    .environmentObject(cart)
                    
                    if rowIndex * 2 + 1 < imageNames.count { // Checks if there is a second image in the row
                        ImageView(
                            name: imageNames[rowIndex * 2 + 1],
                            selectedImageIndex: $selectedImageIndex,
                            showFullScreen: $showFullScreen,
                            scale: $scale,
                            lastScale: $lastScale,
                            offset: $offset,
                            lastOffset: $lastOffset,
                            imageNames: imageNames
                        )
                        .environmentObject(cart)
                    }
                }
            }
        }
    }
}
