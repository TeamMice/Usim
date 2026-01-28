//
//  CameraView.swift
//  Dorgu
//
//  Created by 이돈혁 on 1/27/26.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    var body: some View {
        ZStack {
            CameraPreview()
                .ignoresSafeArea(edges: .top)
        }
        .navigationTitle("카메라")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CameraPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CameraViewController {
        CameraViewController()
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

final class CameraViewController: UIViewController {
    private let session = AVCaptureSession()

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
}
