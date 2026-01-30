//
//  UsimView.swift
//  Dorgu
//
//  Created by 이돈혁 on 1/29/26.
//

import SwiftUI
import PhotosUI
import Vision

struct UsimView: View {
    @State private var messageText: String = ""
    @State private var isLoading: Bool = false
    @State private var resultText: String = ""
    @State private var isCameraPresented: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showQRFailAlert: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                ZStack(alignment: .topLeading) {
                    if messageText.isEmpty {
                        Text("의심되는 문자 내용을 붙여넣으세요")
                            .foregroundStyle(.gray)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 16)
                    }

                    TextEditor(text: $messageText)
                        .frame(height: 60)
                        .scrollContentBackground(.hidden)
                        .padding(8)
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 245/255, green: 245/255, blue: 245/255))
                )
                
                HStack(spacing: 12) {

                    // 메인 버튼: 지금 확인하기
                    Button {
                        Task {
                            await analyzeMessage()
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 217/255, green: 217/255, blue: 217/255))

                            if isLoading {
                                ProgressView()
                            } else {
                                Text("지금 확인하기")
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(height: 44)
                    }
                    .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                    .frame(maxWidth: .infinity)

                    // 카메라 버튼 (초안)
                    Button {
                        isCameraPresented = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 245/255, green: 245/255, blue: 245/255))

                            Image(systemName: "camera")
                                .foregroundStyle(.primary)
                        }
                        .frame(width: 44, height: 44)
                    }

                    PhotosPicker(
                        selection: $selectedPhotoItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 245/255, green: 245/255, blue: 245/255))

                            Image(systemName: "photo.on.rectangle")
                                .foregroundStyle(.primary)
                        }
                        .frame(width: 44, height: 44)
                    }
                }
                
                TextEditor(text: $resultText)
                    .frame(height: 60)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 245/255, green: 245/255, blue: 245/255))
                    )
                    .disabled(true)
                
                Spacer()
            }
            .padding()
            .navigationTitle("의심되면, 혼자 판단하지 마세요")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isCameraPresented) {
                CameraView { qr in
                    messageText = qr
                    isCameraPresented = false
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                guard let newItem else { return }

                Task {
                    await detectQRFromPhotoItem(newItem)
                }
            }
            .alert("QR 코드 인식 실패", isPresented: $showQRFailAlert) {
                Button("확인", role: .cancel) { }
            } message: {
                Text("해당 사진에서 QR 코드를 인식하지 못했습니다.")
            }
        }
    }

    private func analyzeMessage() async {
        guard let url = URL(string: "https://api-production-eb90.up.railway.app/analyze-message") else {
            print("Invalid URL")
            return
        }

        isLoading = true
        defer { isLoading = false }

        let body: [String: Any] = [
            "text": messageText
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let responseString = String(data: data, encoding: .utf8) ?? ""
            print("📡 서버 응답:", responseString)
            resultText = responseString
        } catch {
            print("❌ 네트워크 오류:", error)
        }
    }

    private func detectQRFromPhotoItem(_ item: PhotosPickerItem) async {
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data),
                  let cgImage = uiImage.cgImage
            else { return }

            let request = VNDetectBarcodesRequest()
            request.symbologies = [.qr]

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try handler.perform([request])

            guard
                let result = request.results?.first,
                let payload = result.payloadStringValue
            else {
                await MainActor.run {
                    showQRFailAlert = true
                }
                return
            }

            // ✅ QR 인식 성공 → 입력창 자동 채움
            await MainActor.run {
                messageText = payload
            }

        } catch {
            print("❌ QR 인식 실패:", error)
        }
    }
}
