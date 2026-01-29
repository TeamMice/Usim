////
////  UsimView.swift
////  Dorgu
////
////  Created by 이돈혁 on 1/29/26.
////
//
//import SwiftUI
//import AVFoundation
//
//struct UsimView: View {
//    @State private var detectedQR: String?
//    @State private var showPopup: Bool = false
//    @State private var showAnalysisView: Bool = false
//
//    var body: some View {
//        ZStack {
//            Color.black.ignoresSafeArea()
//
//            if showPopup, let detectedQR {
//                VStack {
//                    Spacer()
//                    HStack {
//                        Image(systemName: "qrcode")
//                        Text(detectedQR)
//                            .lineLimit(1)
//                            .truncationMode(.middle)
//                    }
//                    .padding()
//                    .background(Color.yellow)
//                    .cornerRadius(12)
//                    .shadow(radius: 6)
//                    .padding(.bottom, 80)
//                    .onTapGesture {
//                        showAnalysisView = true
//                    }
//                }
//                .transition(.move(edge: .bottom).combined(with: .opacity))
//            }
//        }
//        .animation(.easeOut, value: showPopup)
//        .navigationTitle("카메라")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationDestination(isPresented: $showAnalysisView) {
//            QRAnalysisResultView(qrText: detectedQR ?? "")
//        }
//    }
//}
//
//
//struct QRAnalysisResultView: View {
//    let qrText: String
//    @State private var analysisResult: String = "분석 중입니다..."
//
//    struct AnalysisResponse: Decodable {
//        let isSpam: Bool
//        let category: String
//        let confidence: Double
//        let reasons: [String]
//    }
//
//    var body: some View {
//        VStack(spacing: 16) {
//            TextEditor(text: $analysisResult)
//                .disabled(true)
//                .padding()
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.gray.opacity(0.3))
//                )
//        }
//        .padding()
//        .navigationTitle("QR 분석 결과")
//        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            analyzeQR()
//        }
//    }
//    
//    private func analyzeQR() {
//        guard let url = URL(string: "https://api-production-eb90.up.railway.app/analyze-url") else {
//            analysisResult = "❌ 서버 URL이 올바르지 않습니다."
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let body: [String: Any] = [
//            "text": qrText
//        ]
//
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//
//        analysisResult = "🔍 QR 코드 분석 중입니다...\n\n\(qrText)"
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    analysisResult = "❌ 네트워크 오류:\n\(error.localizedDescription)"
//                }
//                return
//            }
//
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    analysisResult = "❌ 서버 응답을 해석할 수 없습니다."
//                }
//                return
//            }
//
//            do {
//                let decoded = try JSONDecoder().decode(AnalysisResponse.self, from: data)
//
//                let header = decoded.isSpam
//                    ? "🚨 위험한 QR 코드입니다"
//                    : "✅ 안전한 QR 코드입니다"
//
//                let confidenceText = String(format: "%.0f%%", decoded.confidence * 100)
//
//                let reasonsText = decoded.reasons
//                    .map { "• \($0)" }
//                    .joined(separator: "\n")
//
//                DispatchQueue.main.async {
//                    analysisResult = """
//                    \(header)
//                    분류: \(decoded.category)
//                    신뢰도: \(confidenceText)
//
//                    판단 근거:
//                    \(reasonsText)
//                    """
//                }
//            } catch {
//                let rawResponse = String(data: data, encoding: .utf8) ?? "⚠️ 응답을 문자열로 변환할 수 없습니다."
//                print("❌ QR 분석 JSON 파싱 실패")
//                print("📡 서버 원문 응답:", rawResponse)
//
//                DispatchQueue.main.async {
//                    analysisResult = "❌ 분석 결과를 파싱하는 데 실패했습니다."
//                }
//            }
//        }.resume()
//    }
//}
