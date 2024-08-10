import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    let imageName: String
    let geometry: GeometryProxy
    let onDismiss: () -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = CameraViewController()
        viewController.imageName = imageName
        viewController.geometry = geometry
        viewController.onDismiss = onDismiss

        // Ensure the view controller is presented in full screen
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }
    }
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var imageName: String?
    var geometry: GeometryProxy?
    var onDismiss: (() -> Void)?
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var imageView: UIImageView?
    private var dismissButton: UIButton?
    private var scale: CGFloat = 1.0
    private var rotationAngle: CGFloat = 0.0 // Store the current rotation angle
    private var dismissButtonTopConstraint: NSLayoutConstraint?
    private var dismissButtonTrailingConstraint: NSLayoutConstraint?
    private var dismissButtonBottomConstraint: NSLayoutConstraint?
    private var dismissButtonLeadingConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("CameraViewController: viewDidLoad")
        checkCameraPermission()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var childForStatusBarHidden: UIViewController? {
        return nil
    }

    @objc private func orientationChanged() {
        updateLayoutForCurrentOrientation()
    }

    private func setupUI() {
        setupCamera()

        dismissButton = UIButton(type: .system)
        dismissButton?.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton?.tintColor = .white
        dismissButton?.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        dismissButton?.translatesAutoresizingMaskIntoConstraints = false
        dismissButton?.imageView?.contentMode = .scaleAspectFit
        if let dismissButton = dismissButton {
            view.addSubview(dismissButton)
        }

        // Add the overlay image and frame
        if let imageName = imageName {
            let image = UIImage(named: imageName)
            imageView = UIImageView(image: image)
            imageView?.contentMode = .scaleAspectFit
            imageView?.translatesAutoresizingMaskIntoConstraints = false
            imageView?.layer.shadowColor = UIColor.lightGray.cgColor
            imageView?.layer.shadowOpacity = 0.8
            imageView?.layer.shadowOffset = CGSize(width: 2, height: 2)
            imageView?.layer.shadowRadius = 5
            if let imageView = imageView {
                view.addSubview(imageView)
            }

            // Set constraints for the image view
            NSLayoutConstraint.activate([
                imageView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                imageView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                imageView!.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
            ])
        }

        // Set initial constraints for the dismiss button
        updateLayoutForCurrentOrientation() // Set initial location of the dismiss button

        // Add pinch gesture for zooming
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        imageView?.addGestureRecognizer(pinchGesture)
        imageView?.isUserInteractionEnabled = true // Enable interaction
    }

    @objc private func dismissView() {
        print("Dismiss button tapped")
        onDismiss?()
    }

    private func setupCamera() {
        print("CameraViewController: setupCamera")
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo

        guard let captureSession = captureSession else {
            print("Failed to create capture session")
            return
        }

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("No video capture device found")
            return
        }

        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                print("Failed to add video input to capture session")
                return
            }
        } catch {
            print("Error creating video input: \(error)")
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = view.layer.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        if let previewLayer = previewLayer {
            view.layer.addSublayer(previewLayer)
        }

        captureSession.startRunning()
        print("CameraViewController: captureSession started running")
    }

    private func checkCameraPermission() {
        print("CameraViewController: checkCameraPermission")
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            print("Camera access authorized")
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        print("Camera access granted")
                        self.setupCamera()
                    }
                } else {
                    print("Camera access denied")
                }
            }
        case .denied, .restricted:
            print("Camera access denied or restricted")
        @unknown default:
            print("Unknown camera access status")
        }
    }

    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard imageView != nil else { return }

        if gesture.state == .began || gesture.state == .changed {
            scale *= gesture.scale
            gesture.scale = 1.0
            applyTransform()
        }
    }

    private func updateLayoutForCurrentOrientation() {
        guard imageView != nil else { return }

        let orientation = UIDevice.current.orientation

        // Adjust the rotation angle based on the specific orientations
        switch orientation {
        case .portrait:
            rotationAngle = 0 // No rotation needed for portrait
            // Set dismiss button to top-right corner in portrait
            updateDismissButtonConstraints(top: 50, leading: nil, trailing: -40, bottom: nil)
        case .landscapeLeft:
            rotationAngle = .pi / 2 // Rotate 90 degrees for landscape left
            // Set dismiss button to top-right corner in landscape (bottom-right as viewed)
            updateDismissButtonConstraints(top: nil, leading: nil, trailing: -40, bottom: -40)
        default:
            break
        }

        applyTransform()
    }

    private func updateDismissButtonConstraints(top: CGFloat?, leading: CGFloat?, trailing: CGFloat?, bottom: CGFloat?) {
        dismissButtonTopConstraint?.isActive = false
        dismissButtonLeadingConstraint?.isActive = false
        dismissButtonTrailingConstraint?.isActive = false
        dismissButtonBottomConstraint?.isActive = false

        if let top = top {
            dismissButtonTopConstraint = dismissButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: top)
            dismissButtonTopConstraint?.isActive = true
        }
        if let leading = leading {
            dismissButtonLeadingConstraint = dismissButton?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading)
            dismissButtonLeadingConstraint?.isActive = true
        }
        if let trailing = trailing {
            dismissButtonTrailingConstraint = dismissButton?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing)
            dismissButtonTrailingConstraint?.isActive = true
        }
        if let bottom = bottom {
            dismissButtonBottomConstraint = dismissButton?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)
            dismissButtonBottomConstraint?.isActive = true
        }
    }

    private func applyTransform() {
        // Apply both the scale and the rotation without altering the orientation
        imageView?.transform = CGAffineTransform(rotationAngle: rotationAngle).scaledBy(x: scale, y: scale)
    }
}

