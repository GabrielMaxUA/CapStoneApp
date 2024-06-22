
import SwiftUI

struct ContentView: View {
    let mainText: String = """
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
    
    let natureText = "Nature"
    let modelsText = "Models"
    let architectureText = "Architecture"

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Image("mainBack") // Replace with your image name
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width * 1.5, // Scale the width to 1.5 times the screen width
                               height: geometry.size.height * 1.5) // Scale the height to 1.5 times the screen height
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center the image
                        .edgesIgnoringSafeArea(.all) // Makes the image fill the entire screen
                    
                    ScrollView(.vertical) {
                        VStack {
                            Image("enoTransp")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 100.0) // Resize and enlarge the image
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: geometry.size.width * 0.8, height: 2)
                                .padding(.bottom, 45.0)
                                
                            Text(mainText)
                                .font(Font.custom("Papyrus", size: 20)) // Set custom font and size
                                .foregroundColor(.white) // Set text color to white
                                .multilineTextAlignment(.center) // Center-align the text
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: geometry.size.width * 0.9, height: 2)
                                .padding(.bottom, 70)
                            
                            // Nature Section
                            NavigationLink(destination: GalleryView(title: natureText)) {
                                VStack {
                                    Image("nature")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 280, height: 280) // Resize and enlarge the image
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color.white, lineWidth: 3)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                        .padding()
                                    
                                    Text(natureText)
                                        .font(Font.custom("Papyrus", size: 25)) // Set custom font and size
                                        .foregroundColor(.white) // Set text color to white
                                        .multilineTextAlignment(.center) // Center-align the text
                                }
                            }
                            
                            // Architecture Section
                            NavigationLink(destination: GalleryView(title: architectureText)) {
                                VStack {
                                    Image("italy")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 280, height: 280) // Resize and enlarge the image
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color.white, lineWidth: 3)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                    
                                    Text(architectureText)
                                        .font(Font.custom("Papyrus", size: 25)) // Set custom font and size
                                        .foregroundColor(.white) // Set text color to white
                                        .multilineTextAlignment(.center) // Center-align the text
                                }
                            }
                            
                            // Models Section
                            NavigationLink(destination: GalleryView(title: modelsText)) {
                                VStack {
                                    Image("models")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 280, height: 280) // Resize and enlarge the image
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color.white, lineWidth: 3)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                        .padding()
                                    
                                    Text(modelsText)
                                        .font(Font.custom("Papyrus", size: 25)) // Set custom font and size
                                        .foregroundColor(.white) // Set text color to white
                                        .multilineTextAlignment(.center) // Center-align the text
                                }
                            }

                            Rectangle()
                                .fill(Color.white)
                                .frame(width: geometry.size.width * 0.9, height: 2)
                                .padding()
                            
                            Rectangle()
                                .fill(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.2))
                                .frame(width: 300, height: 60)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .cornerRadius(12.0)
                                .overlay(
                                    HStack(spacing: 10) {
                                        Image("facebook") // Replace with your image name
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(.trailing, 40.0)
                                            .padding(.leading, -5.0)
                                                                            
                                        Image("viber") // Replace with your image name
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(.leading, 10.0)
                                                                            
                                        Image("instagram") // Replace with your image name
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(.leading, 50.0)
                                    }
                                    .padding()
                                )
                        }
                    }
                    .padding(.bottom, 15)
                    .padding(.top, 50)
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct GalleryView: View {
    let title: String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("mainBack") // Replace with your image name
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 1.5, // Scale the width to 1.5 times the screen width
                           height: geometry.size.height * 1.5) // Scale the height to 1.5 times the screen height
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center the image
                    .edgesIgnoringSafeArea(.all) // Makes the image fill the entire screen
                
                ScrollView(.vertical) {
                    VStack {
                        ZStack {
                            Image("enoTransp")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 100.0)
                                .offset(x: 0, y: 0)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 50) // Adjust padding for safe area
                        
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: geometry.size.width * 0.8, height: 2)
                            .padding(.bottom, 45.0)
                        
                        VStack {
                            Text(title)
                                .font(Font.custom("Papyrus", size: 30))
                                .padding()
                            
                            if title == "Nature" {
                                natureGallery()
                            }
                            if title == "Architecture" {
                                architectureGallery()
                            }
                            if title == "Models" {
                                modelsGallery()
                            }

                            Spacer()
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("")
                            }
                            .foregroundColor(.white)
                            .font(.system(size: 24)) 
                        }
                        .padding()
                        .background(Color.black.opacity(0))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(x: -170, y: 35)
                    }
                     // Adjust top and leading padding as needed
                    Spacer()
                }
                .padding(.bottom, 15)
                .padding(.top, 50)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private func natureGallery() -> some View {
        VStack {
            HStack {
                imageView(name: "Npic1")
                imageView(name: "Npic2")
            }
            HStack {
                imageView(name: "Npic3")
                imageView(name: "Npic4")
            }
            HStack {
                imageView(name: "Npic5")
                imageView(name: "Npic6")
            }
            HStack {
                imageView(name: "Npic7")
                imageView(name: "Npic8")
            }
            HStack {
                imageView(name: "Npic9")
                imageView(name: "Npic10")
            }
        }
    }
    
    private func architectureGallery() -> some View {
        VStack {
            HStack {
                imageView(name: "Apic1")
                imageView(name: "Apic2")
            }
            HStack {
                imageView(name: "Apic3")
                imageView(name: "Apic4")
            }
            HStack {
                imageView(name: "Apic5")
                imageView(name: "Apic6")
            }
            HStack {
                imageView(name: "Apic7")
                imageView(name: "Apic8")
            }
            HStack {
                imageView(name: "Apic9")
                imageView(name: "Apic10")
            }
        }
    }
    
    private func modelsGallery() -> some View {
        VStack {
            HStack {
                imageView(name: "Mpic1")
                imageView(name: "Mpic2")
            }
            HStack {
                imageView(name: "Mpic3")
                imageView(name: "Mpic4")
            }
            HStack {
                imageView(name: "Mpic5")
                imageView(name: "Mpic6")
            }
            HStack {
                imageView(name: "Mpic7")
                imageView(name: "Mpic8")
            }
            HStack {
                imageView(name: "Mpic9")
                imageView(name: "Mpic10")
            }
        }
    }
    private func imageView(name: String) -> some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 160, height: 160) // Resize and enlarge the image
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white, lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
