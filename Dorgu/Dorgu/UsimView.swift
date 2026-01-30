//
//  UsimView.swift
//  Dorgu
//
//  Created by 이돈혁 on 1/29/26.
//

import SwiftUI

struct UsimView: View {
    @State private var messageText: String = ""
    @State private var isLoading: Bool = false
    @State private var resultText: String = ""
    @State private var isCameraPresented: Bool = false

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

                    // 사진 버튼 (초안)
                    Button {
                        // TODO: Photo library action
                    } label: {
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
                CameraView()
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
}
