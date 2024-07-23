import SwiftUI

class Cart: ObservableObject {
    @Published var items: [CartItem] = []

    func addItem(imageName: String) {
        if !items.contains(where: { $0.imageName == imageName }) {
            items.append(CartItem(imageName: imageName))
            print("Added item: \(imageName)") // Debug print
            print("Current cart items: \(items)") // Debug print
        }
    }

    func removeItem(imageName: String) {
        items.removeAll { $0.imageName == imageName }
        print("Removed item: \(imageName)")
    }

    func isInCart(imageName: String) -> Bool {
        return items.contains { $0.imageName == imageName }
    }
}

struct CartItem: Codable {
    let imageName: String
}
