//
//  MessageView.swift
//  Dorgu
//
//  Created by 이돈혁 on 1/27/26.
//

import SwiftUI

struct HomeView: View {
    @State private var messageText: String = ""
    @State private var isLoading: Bool = false
    @State private var resultText: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextEditor(text: $messageText)
                    .frame(minHeight: 100)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3))
                    )
                TextEditor(text: $resultText)
                    .frame(minHeight: 100)
                    .padding()
                    .disabled(true)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3))
                    )

                Button {
                    Task {
                        await analyzeMessage()
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("분석")
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)

                Spacer()
            }
            .padding()
            .navigationTitle("메시지")
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
