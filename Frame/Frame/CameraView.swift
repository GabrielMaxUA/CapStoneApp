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
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
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
    private var lastScale: CGFloat = 1.0
    private var dismissButtonTopConstraint: NSLayoutConstraint?
    private var dismissButtonTrailingConstraint: NSLayoutConstraint?
    private var dismissButtonBottomConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("CameraViewController: viewDidLoad")
        checkCameraPermission()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
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

    @objc private func orientationChanged() {
        updateLayoutForCurrentOrientation()
    }

    private func setupUI() {
        setupCamera()

        let dismissButton = UIButton(type: .system)
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.tintColor = .white
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.imageView?.contentMode = .scaleAspectFit
        self.dismissButton = dismissButton
        view.addSubview(dismissButton)
        print("Dismiss button added to view")

        // Set initial constraints for the dismiss button
        dismissButtonTrailingConstraint = dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        dismissButtonTopConstraint = dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        dismissButtonBottomConstraint = dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        
        dismissButtonTrailingConstraint?.isActive = true
        dismissButtonTopConstraint?.isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 27).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 27).isActive = true

        // Set initial constraints for the image view
        if let imageView = imageView {
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
            ])
        }

        updateLayoutForCurrentOrientation()
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

        // Add the overlay image
        if let imageName = imageName, let geometry = geometry {
            let image = UIImage(named: imageName)
            imageView = UIImageView(image: image)
            imageView?.contentMode = .scaleAspectFit
            imageView?.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView!)
            print("Image view added to view")

        } else {
            print("CameraViewController: imageName or geometry is nil")
        }
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

    private func updateLayoutForCurrentOrientation() {
        guard let imageView = imageView, let dismissButton = dismissButton else { return }

        let orientation = UIDevice.current.orientation

        if orientation.isLandscape {
            dismissButtonTopConstraint?.isActive = false
            dismissButtonBottomConstraint?.isActive = true
        } else {
            dismissButtonBottomConstraint?.isActive = false
            dismissButtonTopConstraint?.isActive = true
        }

        // Adjust image view transform for the current orientation
        if orientation.isLandscape {
            imageView.transform = CGAffineTransform(rotationAngle: .pi / 2).scaledBy(x: scale, y: scale)
        } else {
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}
