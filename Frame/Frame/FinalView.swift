import SwiftUI
import Combine
import MapKit
import CoreLocation

class PrintShopFetcher: ObservableObject {
    @Published var printShops: [MKPointAnnotation] = []
    
    func fetchNearbyPrintShops(region: MKCoordinateRegion) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "print shop"
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let newAnnotations = response.mapItems.map { item -> MKPointAnnotation in
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                return annotation
            }
            
            DispatchQueue.main.async {
                self.printShops = newAnnotations
            }
        }
    }
}

struct FinalView: View {
    @EnvironmentObject var cart: Cart // Access Cart instance from environment
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // Environment variable to handle presentation mode
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var userTrackingMode: MKUserTrackingMode = .follow
    @State private var showingAlert = false
    @State private var showPolicyAlert = false
    
    @StateObject private var printShopFetcher = PrintShopFetcher()
    
    var onBack: (() -> Void)? // Closure for back button action
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Background image
                    Image("mainBack")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width * 1.5, height: geometry.size.height * 1.5)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        HeaderView(geometry: geometry, showChevron: false, showCart: false, onBack: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        Spacer()
                        ScrollView(.vertical) {
                            VStack(spacing: 20) {
                                Text("Thank You for Your Order")
                                    .font(Font.custom("Papyrus", size: 30))
                                    .foregroundColor(.white)
                                TextView(mainText: """
                                Thank you for working with us!
                                We will send you an archive with your order directly to your email.
                                
                                Please read our license agreement.
                                
                                If you would like to choose the closest high-quality print shop to bring your art to life, click on the map below.
                                
                                We hope to see you back as our gallery is always updating.
                                """, onPolicyTap: {
                                    self.showPolicyAlert = true
                                })
                                .frame(height: geometry.size.width * 0.9)
                                
                                NavigationLink(destination: FrameContentView().onAppear {
                                    cart.items.removeAll()
                                }) {
                                    Text("Back to Homepage")
                                        .padding()
                                        .background(Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .font(Font.custom("Papyrus", size: 18))
                                }
                                Spacer()
                                NavigationLink(destination: FullScreenMapView(region: $region, userTrackingMode: $userTrackingMode, annotations: $printShopFetcher.printShops)) {
                                    MapView(region: $region, userTrackingMode: $userTrackingMode, annotations: $printShopFetcher.printShops, fetchNearbyPrintShops: fetchNearbyPrintShops, showingAlert: $showingAlert)
                                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.2)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        Spacer()
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: geometry.size.width * 0.6, height: 2)
                            .padding(.bottom, 10)
                        SocialMediaLinks()
                            .padding(.bottom, -15)
                    }
                }
                .onAppear {
                    checkLocationServices()
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Location Access Denied"), message: Text("Please enable location services in Settings."), dismissButton: .default(Text("OK")))
                }
                .alert(isPresented: $showPolicyAlert) {
                    Alert(title: Text("License Agreement"), message: Text("All copyrights are reserved and any tampering/resell/copy of content will lead to legal charges and may lead to imprisonment"), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true) // Hide the navigation bar
        }
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            let locationManager = CLLocationManager()
            locationManager.delegate = Coordinator(self)
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // Ensure location permission is requested
        } else {
            showingAlert = true
        }
    }
    
    private func fetchNearbyPrintShops(latitude: Double, longitude: Double) {
        region.center.latitude = latitude
        region.center.longitude = longitude
        printShopFetcher.fetchNearbyPrintShops(region: region)
    }
    
    struct MapView: UIViewRepresentable {
        @Binding var region: MKCoordinateRegion
        @Binding var userTrackingMode: MKUserTrackingMode
        @Binding var annotations: [MKPointAnnotation]
        let fetchNearbyPrintShops: (Double, Double) -> Void
        @Binding var showingAlert: Bool
        
        func makeUIView(context: Context) -> MKMapView {
            let mapView = MKMapView()
            mapView.userTrackingMode = userTrackingMode
            mapView.delegate = context.coordinator
            mapView.showsUserLocation = true
            context.coordinator.checkLocationAuthorization() // Ensure location authorization is checked
            return mapView
        }
        
        func updateUIView(_ uiView: MKMapView, context: Context) {
            uiView.setRegion(region, animated: true)
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
        }
        
        func makeCoordinator() -> MapViewCoordinator {
            MapViewCoordinator(self)
        }
        
        class MapViewCoordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
            var parent: MapView
            var locationManager: CLLocationManager
            
            init(_ parent: MapView) {
                self.parent = parent
                self.locationManager = CLLocationManager()
                super.init()
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.requestWhenInUseAuthorization()
            }
            
            func checkLocationAuthorization() {
                switch locationManager.authorizationStatus {
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                case .restricted, .denied:
                    parent.showingAlert = true // Show alert if location services are denied
                case .authorizedWhenInUse, .authorizedAlways:
                    locationManager.startUpdatingLocation()
                @unknown default:
                    break
                }
            }
            
            func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
                let newCoordinate = userLocation.coordinate
                let currentSpan = parent.region.span
                
                if abs(newCoordinate.latitude - parent.region.center.latitude) > 0.005 || abs(newCoordinate.longitude - parent.region.center.longitude) > 0.005 {
                    parent.region = MKCoordinateRegion(
                        center: newCoordinate,
                        span: currentSpan
                    )
                    parent.fetchNearbyPrintShops(newCoordinate.latitude, newCoordinate.longitude) // Corrected argument labels
                }
            }
            
            func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    manager.startUpdatingLocation()
                } else {
                    parent.showingAlert = true
                }
            }
            
            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                if let location = locations.last {
                    let newCoordinate = location.coordinate
                    let currentSpan = parent.region.span
                    
                    if abs(newCoordinate.latitude - parent.region.center.latitude) > 0.005 || abs(newCoordinate.longitude - parent.region.center.longitude) > 0.005 {
                        parent.region = MKCoordinateRegion(
                            center: newCoordinate,
                            span: currentSpan
                        )
                        parent.fetchNearbyPrintShops(newCoordinate.latitude, newCoordinate.longitude) // Corrected argument labels
                    }
                }
            }
        }
    }
    
    class Coordinator: NSObject, CLLocationManagerDelegate {
        var parent: FinalView
        var locationManager: CLLocationManager
        
        init(_ parent: FinalView) {
            self.parent = parent
            self.locationManager = CLLocationManager()
            super.init()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                manager.startUpdatingLocation()
            } else {
                parent.showingAlert = true
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                let newCoordinate = location.coordinate
                let currentSpan = parent.region.span
                
                if abs(newCoordinate.latitude - parent.region.center.latitude) > 0.005 || abs(newCoordinate.longitude - parent.region.center.longitude) > 0.005 {
                    parent.region = MKCoordinateRegion(
                        center: newCoordinate,
                        span: currentSpan
                    )
                    parent.fetchNearbyPrintShops(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude) // Corrected argument labels
                }
            }
        }
    }
}

struct TextView: UIViewRepresentable {
    var mainText: String
    var onPolicyTap: () -> Void
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.attributedText = makeAttributedString()
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue] // Update link color to light blue
        textView.font = UIFont(name: "Papyrus", size: 19) // Matching the font and size
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeAttributedString() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attributedString = NSMutableAttributedString(string: mainText, attributes: [
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle,
            .font: UIFont(name: "Papyrus", size: 19)!
        ])
        
        let policyRange = (mainText as NSString).range(of: "license agreement")
        attributedString.addAttribute(.link, value: "policy://", range: policyRange)
        
        return attributedString
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        
        init(_ parent: TextView) {
            self.parent = parent
        }
        
        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            if URL.scheme == "policy" {
                parent.onPolicyTap()
                return false
            }
            return true
        }
    }
}

struct FullScreenMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var userTrackingMode: MKUserTrackingMode
    @Binding var annotations: [MKPointAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.userTrackingMode = userTrackingMode
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        context.coordinator.checkLocationAuthorization() // Ensure location authorization is checked
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.addAnnotations(annotations)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: FullScreenMapView
        var locationManager: CLLocationManager
        
        init(_ parent: FullScreenMapView) {
            self.parent = parent
            self.locationManager = CLLocationManager()
            super.init()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        func checkLocationAuthorization() {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                // Show an alert instructing how to enable location services
                break
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            @unknown default:
                break
            }
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let newCoordinate = userLocation.coordinate
            let currentSpan = parent.region.span
            
            if abs(newCoordinate.latitude - parent.region.center.latitude) > 0.005 || abs(newCoordinate.longitude - parent.region.center.longitude) > 0.005 {
                parent.region = MKCoordinateRegion(
                    center: newCoordinate,
                    span: currentSpan
                )
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                manager.startUpdatingLocation()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                let newCoordinate = location.coordinate
                let currentSpan = parent.region.span
                
                if abs(newCoordinate.latitude - parent.region.center.latitude) > 0.005 || abs(newCoordinate.longitude - parent.region.center.longitude) > 0.005 {
                    parent.region = MKCoordinateRegion(
                        center: newCoordinate,
                        span: currentSpan
                    )
                }
            }
        }
    }
}

struct FinalView_Previews: PreviewProvider {
    static var previews: some View {
        FinalView()
            .environmentObject(Cart())
    }
}
