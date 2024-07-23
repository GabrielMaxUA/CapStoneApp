import SwiftUI
import UIKit

class FrameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a UIHostingController with the SwiftUI view
        let frameContentView = FrameContentView()
        let hostingController = UIHostingController(rootView: frameContentView)
        
        // Add the hosting controller as a child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        // Set constraints for the hosting controller's view
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Notify the hosting controller that it has been moved to a parent
        hostingController.didMove(toParent: self)
    }
}
