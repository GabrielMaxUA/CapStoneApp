import SwiftUI
import Combine
import ZIPFoundation
import SwiftSMTP

struct Checkout: View {
    let title = "Check out"
    @EnvironmentObject var cart: Cart
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let imageNames: [String]
    var onBack: (() -> Void)?
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var middleName: String = ""
    @State private var cardNumber: String = ""
    @State private var CVVNumber: String = ""
    @State private var Email: String = ""
    @State private var emailFieldActive: Bool = false
    @State private var showInvalidEmailAlert: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToFinalView = false
    
    private let pricePerImage: Double = 59.99
    
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
                    
                    VStack(spacing: 0) {
                        HeaderView(geometry: geometry, showChevron: true, showCart: false, onBack: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        
                        Text(title)
                            .font(Font.custom("Papyrus", size: 30))
                            .foregroundColor(.white)
                            .padding(.bottom, 0)
                        
                        VStack {
                            // Name input fields
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
                                        .frame(width: 150)
                                        .padding(.trailing, 10)
                                        .autocorrectionDisabled(true)
                                        .onChange(of: firstName) { newValue in
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
                                        .frame(width: 150)
                                        .padding(.trailing, 10)
                                        .autocorrectionDisabled(true)
                                        .onChange(of: lastName) { newValue in
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
                                    .frame(width: 150)
                                    .padding(.trailing, 10)
                                    .autocorrectionDisabled(true)
                                    .onChange(of: middleName) { newValue in
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
                                HStack {
                                    if cardNumber.isEmpty {
                                        Text("*")
                                            .foregroundColor(.red)
                                    }
                                    TextField("---- ---- ---- ----", text: $cardNumber)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.numberPad)
                                        .frame(width: 150)
                                        .padding(.trailing, 10)
                                        .onReceive(Just(cardNumber)) { _ in
                                            formatCardNumber()
                                        }
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
                                        .frame(width: 50)
                                        .padding(.trailing, 10)
                                        .onChange(of: CVVNumber) { newValue in
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
                                    } else if Email.isEmpty{
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
                                .frame(width: 200)
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
                        
                        NavigationLink(
                            destination: FinalView()
                                .environmentObject(cart)
                                .navigationBarHidden(true),
                            isActive: $navigateToFinalView,
                            label: {
                                EmptyView()
                            })
                        
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
                .background(Color.black.edgesIgnoringSafeArea(.all))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
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
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func totalAmount() -> Double {
        let subtotal = Double(imageNames.count) * pricePerImage
        let tax = subtotal * 0.13
        return subtotal + tax
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
            cart.checkout()
            navigateToFinalView = true
        }
    }
    
    private func createArchive() -> URL? {
        let fileManager = FileManager.default
        let tempDirURL = fileManager.temporaryDirectory
        let archiveURL = tempDirURL.appendingPathComponent("YourOrder.zip")
        
        do {
            if fileManager.fileExists(atPath: archiveURL.path) {
                try fileManager.removeItem(at: archiveURL)
            }
            
            try fileManager.createDirectory(at: tempDirURL, withIntermediateDirectories: true, attributes: nil)
            
            let archive = try Archive(url: archiveURL, accessMode: .create)
            
            for imageName in imageNames {
                if let image = UIImage(named: imageName),
                   let imageData = image.pngData() {
                    let imageURL = tempDirURL.appendingPathComponent(imageName)
                    try imageData.write(to: imageURL)
                    try archive.addEntry(with: imageName, fileURL: imageURL, compressionMethod: .deflate)
                    try fileManager.removeItem(at: imageURL)
                }
            }
            
            return archiveURL
        } catch {
            print("Failed to create archive: \(error)")
            return nil
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
