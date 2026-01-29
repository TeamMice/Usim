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
        CameraPreview { _ in
            // QR 감지는 유지하되, 이 뷰에서는 아무 UI 반응도 하지 않음
        }
        .ignoresSafeArea()
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


struct QRAnalysisResultView: View {
    let qrText: String
    @State private var analysisResult: String = "분석 중입니다..."

    struct AnalysisResponse: Decodable {
        let isSpam: Bool
        let category: String
        let confidence: Double
        let reasons: [String]
    }

    var body: some View {
        VStack(spacing: 16) {
            TextEditor(text: $analysisResult)
                .disabled(true)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3))
                )
        }
        .padding()
        .navigationTitle("QR 분석 결과")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            analyzeQR()
        }
    }
    
    private func analyzeQR() {
        guard let url = URL(string: "https://api-production-eb90.up.railway.app/analyze-url") else {
            analysisResult = "❌ 서버 URL이 올바르지 않습니다."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "text": qrText
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        analysisResult = "🔍 QR 코드 분석 중입니다...\n\n\(qrText)"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    analysisResult = "❌ 네트워크 오류:\n\(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    analysisResult = "❌ 서버 응답을 해석할 수 없습니다."
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(AnalysisResponse.self, from: data)

                let header = decoded.isSpam
                    ? "🚨 위험한 QR 코드입니다"
                    : "✅ 안전한 QR 코드입니다"

                let confidenceText = String(format: "%.0f%%", decoded.confidence * 100)

                let reasonsText = decoded.reasons
                    .map { "• \($0)" }
                    .joined(separator: "\n")

                DispatchQueue.main.async {
                    analysisResult = """
                    \(header)
                    분류: \(decoded.category)
                    신뢰도: \(confidenceText)

                    판단 근거:
                    \(reasonsText)
                    """
                }
            } catch {
                let rawResponse = String(data: data, encoding: .utf8) ?? "⚠️ 응답을 문자열로 변환할 수 없습니다."
                print("❌ QR 분석 JSON 파싱 실패")
                print("📡 서버 원문 응답:", rawResponse)

                DispatchQueue.main.async {
                    analysisResult = "❌ 분석 결과를 파싱하는 데 실패했습니다."
                }
            }
        }.resume()
    }
}
