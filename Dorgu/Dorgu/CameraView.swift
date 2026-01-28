//
//  CameraView.swift
//  Dorgu
//
//  Created by 이돈혁 on 1/27/26.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @State private var detectedQR: String?
    @State private var showPopup: Bool = false

    var body: some View {
        ZStack {
            CameraPreview { qr in
                detectedQR = qr
                showPopup = true
            }
            .ignoresSafeArea()

            if showPopup, let detectedQR {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "qrcode")
                        Text(detectedQR)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(12)
                    .shadow(radius: 6)
                    .padding(.bottom, 80)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeOut, value: showPopup)
        .navigationTitle("카메라")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CameraPreview: UIViewControllerRepresentable {
    let onDetect: (String) -> Void

    func makeUIViewController(context: Context) -> CameraViewController {
        CameraViewController(onDetect: onDetect)
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

final class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    private let session = AVCaptureSession()
    private let onDetect: (String) -> Void
    private var lastDetectedQR: String?
    private var lastDetectionTime: Date = .distantPast

    init(onDetect: @escaping (String) -> Void) {
        self.onDetect = onDetect
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureSession()
        setupPreview()
        session.startRunning()
    }

    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else {
            session.commitConfiguration()
            return
        }

        session.addInput(input)

        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }

        session.commitConfiguration()
    }

    private func setupPreview() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.sublayers?.first?.frame = view.bounds
    }
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard
            let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let qrString = object.stringValue
        else {
            return
        }

        let now = Date()

        // iOS 카메라앱 스타일: 카메라는 계속 돌리고,
        // 마지막으로 인식한 QR만 유지
        if qrString != lastDetectedQR || now.timeIntervalSince(lastDetectionTime) > 1.0 {
            lastDetectedQR = qrString
            lastDetectionTime = now

            print("📷 QR Detected:", qrString)
            onDetect(qrString)
        }
    }
}
