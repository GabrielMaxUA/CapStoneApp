import SwiftUI

class Cart: ObservableObject {
    @Published var items: [CartItem] = [] {
        didSet {
            saveCartItems()
        }
    }
    
    init() {
        loadCartItems()
    }

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
    
    func checkout() {
        for index in items.indices {
            items[index].isCheckedOut = true
        }
        saveCartItems()
    }
    
    
    private func saveCartItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "cartItems")
            print("Saved cart items to UserDefaults: \(items.map { $0.imageName })")
        }
    }

    private func loadCartItems() {
        if let savedItems = UserDefaults.standard.data(forKey: "cartItems") {
            if let decodedItems = try? JSONDecoder().decode([CartItem].self, from: savedItems) {
                self.items = decodedItems
                print("Loaded cart items from UserDefaults: \(items.map { $0.imageName })")
            }
        }
    }
}

struct CartItem: Codable, Equatable {
    let imageName: String
    var isCheckedOut: Bool = false
}
