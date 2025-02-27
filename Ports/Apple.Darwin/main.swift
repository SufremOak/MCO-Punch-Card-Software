import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var resumePattern: String = ""
    @State private var grid: [[String]] = Array(repeating: Array(repeating: ".", count: 3), count: 6)
    @State private var showScanner = false
    @State private var selectedTab = "Scan Card"

    var body: some View {
        NavigationView {
            VStack {
                Picker("Mode", selection: $selectedTab) {
                    Text("Scan Card").tag("Scan Card")
                    Text("Input Bits").tag("Input Bits")
                    Text("About").tag("About")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedTab == "Scan Card" {
                    Button("Scan MCO Punch Card") {
                        showScanner = true
                    }
                    .padding()
                    .sheet(isPresented: $showScanner) {
                        ScannerView { scannedText in
                            resumePattern = scannedText
                            parsePattern()
                        }
                    }
                } else if selectedTab == "Input Bits" {
                    TextField("Enter Resume-Pattern", text: $resumePattern, onCommit: parsePattern)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    GridView(grid: grid)
                } else if selectedTab == "About" {
                    Text("Flipent UI - A tool for interpreting MCO Punch Cards.")
                        .padding()
                }
            }
            .navigationTitle("Flipent")
        }
    }

    func parsePattern() {
        let parsedGrid = FlipentParser.parse(resumePattern, rows: 6, cols: 3)
        grid = parsedGrid
    }
}

struct GridView: View {
    let grid: [[String]]

    var body: some View {
        VStack {
            ForEach(0..<grid.count, id: \ .self) { row in
                HStack {
                    ForEach(0..<grid[row].count, id: \ .self) { col in
                        Text(grid[row][col])
                            .frame(width: 30, height: 30)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black)
                    }
                }
            }
        }
        .padding()
    }
}

struct ScannerView: UIViewControllerRepresentable {
    var completion: (String) -> Void

    func makeUIViewController(context: Context) -> ScannerViewController {
        let controller = ScannerViewController()
        controller.completion = completion
        return controller
    }

    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var completion: ((String) -> Void)?
    private var captureSession: AVCaptureSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let stringValue = metadataObject.stringValue {
            captureSession.stopRunning()
            completion?(stringValue)
            dismiss(animated: true)
        }
    }
}
