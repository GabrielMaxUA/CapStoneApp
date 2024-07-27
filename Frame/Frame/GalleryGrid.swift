import SwiftUI

struct GalleryGrid: View {
    let imageNames: [String]
    @Binding var selectedImageIndex: Int
    @Binding var showFullScreen: Bool
    @Binding var scale: CGFloat
    @Binding var lastScale: CGFloat
    @Binding var offset: CGSize
    @Binding var lastOffset: CGSize
    @Binding var selectedImages: Set<Int>
    @Binding var editMode: Bool
    @Binding var checkout: Bool
    @EnvironmentObject var cart: Cart

    var body: some View {
        if editMode {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(imageNames.indices, id: \.self) { index in
                    ZStack {
                        Image(imageNames[index])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                if selectedImages.contains(index) {
                                    selectedImages.remove(index)
                                } else {
                                    selectedImages.insert(index)
                                }
                            }
                        if selectedImages.contains(index) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                    }
                }
                .padding()
            }
        } else if checkout {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(imageNames.indices, id: \.self) { index in
                    Image(imageNames[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding()
        } else {
            VStack {
                ForEach(0..<(imageNames.count + 1) / 2, id: \.self) { rowIndex in
                    HStack {
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

                        if rowIndex * 2 + 1 < imageNames.count {
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
}
