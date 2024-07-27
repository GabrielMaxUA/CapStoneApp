import SwiftUI
import Combine

struct Checkout: View {
    let title = """
Check out
"""
    //var amount: Double
    @EnvironmentObject var cart: Cart // Access Cart instance from environment
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // Environment variable to handle presentation mode
    let imageNames: [String] // Names of the images in the gallery
    var onBack: (() -> Void)? // Closure for back button action
    @State private var firstName: String = "" // State variable for first name input
    @State private var lastName: String = "" // State variable for last name input
    @State private var middleName: String = ""    
    @State private var cardNumber: String = ""
    @State private var CVVNumber: String = ""
    @State private var Email: String = ""
    @State private var showInvalidEmailAlert: Bool = false
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
                            TextField("First Name", text: $firstName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 150) // Adjust width as needed
                                .padding(.trailing, 10)
                                .autocorrectionDisabled(true)
                                .onChange(of: firstName) { oldValue, newValue in
                                filterLettersOnly(&firstName, newValue:newValue)
                                                    }
                        }
                        
                        HStack {
                            Text("Please enter your last name:")
                                .font(Font.custom("Papyrus", size: 17))
                                .foregroundColor(.white)
                                .padding(.bottom, 0)
                                .padding(.leading, 10)
                            Spacer()
                            TextField("Last Name", text: $lastName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 150) // Adjust width as needed
                                .padding(.trailing, 10)
                                .autocorrectionDisabled(true)
                                .onChange(of: lastName) { oldValue, newValue in
                                filterLettersOnly(&lastName, newValue: newValue)
                                                    }
                        }
                        HStack {
                            Text("Please enter your middle name:")
                                .font(Font.custom("Papyrus", size: 17))
                                .foregroundColor(.white)
                                .padding(.bottom, 0)
                                .padding(.leading, 10)
                            Spacer()
                            TextField("Middle Name", text: $middleName)
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
                            TextField("CVV", text: $CVVNumber)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 50) // Adjust width as needed
                                .padding(.trailing, 10)
                                .onChange(of: CVVNumber) { oldValue, newValue in
                                formatCVVNumber()
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
                            TextField("Email", text: $Email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200) // Adjust width as needed
                            .padding(.trailing, 10)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .onChange(of: Email) { oldValue, newValue in
                            showInvalidEmailAlert = !isValidEmail(newValue)
                                }
                            }

                            if showInvalidEmailAlert {
                                Text("Invalid email address")
                                .font(Font.custom("Papyrus", size: 14))
                                .foregroundColor(.red)
                                .padding(.top, 5)
                        }
                        HStack{
                            Spacer()
                            Text("Total amount to purchase:")
                                .font(Font.custom("Papyrus", size: 20))
                                .foregroundColor(.white)
                                .padding(.bottom, 0)
                                .padding(.leading, 10)
                                .padding(.top, 10)
                            Spacer()
                            
                        }
                       
                    }
                    .padding(.top, 20)
                   // .background(.yellow)
                    Spacer()
                    NavigationLink(destination: Checkout(imageNames: cart.items.map { $0.imageName }).environmentObject(cart)) {
                            Text("Check Out")
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
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
}

struct Checkout_Previews: PreviewProvider {
    static var previews: some View {
        Checkout(imageNames: ["Mpic1", "Mpic2", "Mpic3", "Mpic4", "Mpic5", "Mpic6", "Mpic7", "Mpic8", "Mpic9", "Mpic10", "Mpic11", "Mpic12", "Mpic13", "Mpic14"])
            .environmentObject(Cart())
            .previewDisplayName("Checkout View")
    }
}
