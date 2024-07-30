import SwiftUI
import Combine

struct Checkout: View {
    let title = """
Check out
"""
    @EnvironmentObject var cart: Cart // Access Cart instance from environment
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // Environment variable to handle presentation mode
    let imageNames: [String] // Names of the images in the gallery
    var onBack: (() -> Void)? // Closure for back button action
    @State private var firstName: String = "" // State variable for first name input
    @State private var lastName: String = "" // State variable for last name input
    @State private var middleName: String = "" // State variable for middle name input
    @State private var cardNumber: String = "" // State variable for card number input
    @State private var CVVNumber: String = "" // State variable for CVV number input
    @State private var Email: String = "" // State variable for email input
    @State private var emailFieldActive: Bool = false // State variable for email field activity
    @State private var showInvalidEmailAlert: Bool = false // State variable for invalid email alert
    @State private var showAlert: Bool = false // State variable for alert visibility
    @State private var alertMessage: String = "" // State variable for alert message
    @State private var selectedImageIndex: Int = 0 // State variable for the selected image index
    @State private var showFullScreen = false // State variable for full-screen view
    @State private var editCart = false // State variable for edit mode
    @State private var checkout = true // State variable for checkout mode
    @State private var selectedImages: Set<Int> = [] // State variable for selected images
    @State private var scale: CGFloat = 1.0 // State variable for image scale
    @State private var lastScale: CGFloat = 1.0 // State variable for last image scale
    @State private var offset: CGSize = .zero // State variable for image offset
    @State private var lastOffset: CGSize = .zero // State variable for last image offset
    @State private var showCrossButton = true

    private let pricePerImage: Double = 59.99

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                Image("mainBack")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 1.5, height: geometry.size.height * 1.5)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    HeaderView(geometry: geometry, showChevron: true, showCart: false, onBack: {
                        self.presentationMode.wrappedValue.dismiss()
                    })

                    Text(title)
                        .font(Font.custom("Papyrus", size: 30))
                        .foregroundColor(.white)
                        .padding(.bottom, 0)
                    VStack {
                        HStack {
                            Text("Please enter your name:")
                                .font(Font.custom("Papyrus", size: 17))
                                .foregroundColor(.white)
                                .padding(.bottom, 0)
                                .padding(.leading, 10)
                            Spacer()
                            HStack {
                                if firstName.isEmpty {
                                    Text("*")
                                        .foregroundColor(.red)
                                }
                                TextField("First Name", text: $firstName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 150) // Adjust width as needed
                                    .padding(.trailing, 10)
                                    .autocorrectionDisabled(true)
                                    .onChange(of: firstName) { oldValue, newValue in
                                        filterLettersOnly(&firstName, newValue: newValue)
                                    }
                            }
                        }
                        
                        HStack {
                            Text("Please enter your last name:")
                                .font(Font.custom("Papyrus", size: 17))
                                .foregroundColor(.white)
                                .padding(.bottom, 0)
                                .padding(.leading, 10)
                            Spacer()
                            HStack {
                                if lastName.isEmpty {
                                    Text("*")
                                        .foregroundColor(.red)
                                }
                                TextField("Last Name", text: $lastName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 150) // Adjust width as needed
                                    .padding(.trailing, 10)
                                    .autocorrectionDisabled(true)
                                    .onChange(of: lastName) { oldValue, newValue in
                                        filterLettersOnly(&lastName, newValue: newValue)
                                    }
                            }
                        }
                        HStack {
                            Text("Please enter your middle name:")
                                .font(Font.custom("Papyrus", size: 17))
                                .foregroundColor(.white)
                                .padding(.bottom, 0)
                                .padding(.leading, 10)
                            Spacer()
                            TextField("Optional", text: $middleName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 150) // Adjust width as needed
                                .padding(.trailing, 10)
                                .autocorrectionDisabled(true)
                                .onChange(of: middleName) { oldValue, newValue in
                                    filterLettersOnly(&middleName, newValue: newValue)
                                }
                        }
                        HStack {
                            Text("Please enter your card number:")
                                .font(Font.custom("Papyrus", size: 17))
                                .foregroundColor(.white)
                                .padding(.bottom, 0)
                                .padding(.leading, 10)
                            Spacer()
                            HStack{
                                if cardNumber.isEmpty {
                                    Text("*")
                                        .foregroundColor(.red)
                                }
                            }
                            TextField("---- ---- ---- ----", text: $cardNumber)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 200) // Adjust width as needed
                                .padding(.trailing, 10)
                                .onReceive(Just(cardNumber)) { _ in
                                    formatCardNumber()
                                }
                        }
                        HStack {
                            Text("Please enter your CVV number:")
                                .font(Font.custom("Papyrus", size: 17))
                                .foregroundColor(.white)
                                .padding(.bottom, 0)
                                .padding(.leading, 10)
                            Spacer()
                            HStack {
                                if CVVNumber.isEmpty {
                                    Text("*")
                                        .foregroundColor(.red)
                                }
                                TextField("CVV", text: $CVVNumber)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 50) // Adjust width as needed
                                    .padding(.trailing, 10)
                                    .onChange(of: CVVNumber) { oldValue, newValue in
                                        formatCVVNumber()
                                    }
                            }
                            Spacer()
                        }
                        HStack {
                            Text("Please enter your Email:")
                                .font(Font.custom("Papyrus", size: 17))
                                .foregroundColor(.white)
                                .padding(.bottom, 0)
                                .padding(.leading, 10)
                            Spacer()
                            HStack {
                                if showInvalidEmailAlert {
                                    Text("!")
                                        .foregroundColor(.red)
                                }
                                else{
                                    Text("*")
                                        .foregroundColor(.red)
                                }
                            }
                                TextField("Email", text: $Email, onEditingChanged: { isActive in
                                    emailFieldActive = isActive
                                    if !isActive {
                                        showInvalidEmailAlert = !isValidEmail(Email)
                                    }
                                })
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 200) // Adjust width as needed
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                                    .autocorrectionDisabled(true)
                            
                        }

                        HStack {
                            Spacer()
                            Text("Total: $\(totalAmount(), specifier: "%.2f")")
                                .font(Font.custom("Papyrus", size: 24))
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                                .padding(.leading, 10)
                                .padding(.top, 10)
                            Spacer()
                        }
                    }
                    .padding(.top, 20)
                    Spacer()
                    Button(action: {
                        validateFields()
                    }) {
                        Text("Place order")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    Spacer()
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: geometry.size.width * 0.6, height: 2)
                        .padding(.bottom, 10)
                    
                    SocialMediaLinks()
                        .padding(.bottom, -10)
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))  // Add black background
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true) // Hide the navigation bar
    }

    private func filterLettersOnly(_ binding: inout String, newValue: String) {
          let filtered = newValue.filter { $0.isLetter }
          if filtered != newValue {
              binding = filtered
          }
      }
    
    private func formatCardNumber() {
           // Filter out non-numeric characters
           let digits = cardNumber.filter { $0.isNumber }
           // Limit to 16 digits
           let limitedDigits = String(digits.prefix(16))
           // Format the digits into groups of 4
           var formatted = ""
           for (index, char) in limitedDigits.enumerated() {
               if index > 0 && index % 4 == 0 {
                   formatted.append("-")
               }
               formatted.append(char)
           }
           cardNumber = formatted
       }
    
    private func formatCVVNumber() {
           // Filter out non-numeric characters and limit to 3 digits
           let digits = CVVNumber.filter { $0.isNumber }
           let limitedDigits = String(digits.prefix(3))
           if limitedDigits != CVVNumber {
               CVVNumber = limitedDigits
           }
       }
    
    private func isValidEmail(_ email: String) -> Bool {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailTest.evaluate(with: email)
      }
    
    private func totalAmount() -> Double {
        let subtotal = Double(imageNames.count) * pricePerImage
        let tax = subtotal * 0.13
        return subtotal + tax
    }
    
    private func loadCartItemsFromUserDefaults() -> [String] {
        if let savedItems = UserDefaults.standard.data(forKey: "cartItems") {
            if let decodedItems = try? JSONDecoder().decode([CartItem].self, from: savedItems) {
                print("Loading cart items for checkout: \(decodedItems.map { $0.imageName })")
                return decodedItems.map { $0.imageName }
            }
        }
        return []
    }

    private func validateFields() {
        var missingFields = [String]()
        
        if firstName.isEmpty {
            missingFields.append("First Name")
        }
        if lastName.isEmpty {
            missingFields.append("Last Name")
        }
        if CVVNumber.isEmpty {
            missingFields.append("CVV Number")
        }
        if !isValidEmail(Email) {
            missingFields.append("Valid Email")
        }
        
        if !missingFields.isEmpty {
            alertMessage = "Please fill in the following fields: \(missingFields.joined(separator: ", "))"
            showAlert = true
        } else {
            // Proceed to checkout
            print("Proceed to checkout")
        }
    }
}

struct Checkout_Previews: PreviewProvider {
    static var previews: some View {
        Checkout(imageNames: [])
            .environmentObject(Cart())
            .previewDisplayName("Checkout View")
    }
}
