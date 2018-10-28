import AVFoundation

public class NRV2EScannerViewController: UIViewController {
    
    let captureSession: AVCaptureSession!
    let previewLayer: AVCaptureVideoPreviewLayer!

    init() {
        captureSession = AVCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configureSession()
        configureView()
    }
    
    private func configureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            fatalError("GRGScannerViewController -> configureSession -> AVCaptureDeviceInput(device: videoCaptureDevice)")
        }
        
        if !captureSession.canAddInput(videoInput) {
            fatalError("GRGScannerViewController -> configureSession -> !captureSession.canAddInput(videoInput)")
        }
        captureSession.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        if !captureSession.canAddOutput(metadataOutput) {
            fatalError("GRGScannerViewController -> configureSession -> !captureSession.canAddOutput(metadataOutput)")
        }
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.aztec]
        
        captureSession.startRunning()
    }
    
    private func configureView() {
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = view.bounds
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}

extension NRV2EScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first, metadataObject.type == .aztec {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            captureSession.stopRunning()
            
            convert(stringValue: stringValue)
        }
    }
    
    private func preparedBase64(from stringValue: String) -> String {
        let remainder = stringValue.count % 4
        if remainder == 0 {
            return stringValue
        } else if remainder == 1 {
            return String(stringValue.dropLast())
        } else {
            let newLength = stringValue.count + (4 - remainder)
            return stringValue.padding(toLength: newLength, withPad: "=", startingAt: 0)
        }
    }
    
    private func convert(stringValue: String) {
        let base64 = preparedBase64(from: stringValue)
        let data = Data(base64Encoded: base64)
        
        let src = [UInt8](data! as Data)
        let decompressor = NRV2EDecompressor()
        let result = decompressor.decompress(src: src)
        let a = String(bytes: result, encoding: .utf16LittleEndian)
        
        let alert = UIAlertController(title: "DANE", message: a, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default) { action in
            alert.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}
