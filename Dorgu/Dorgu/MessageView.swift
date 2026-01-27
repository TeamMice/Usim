//
//  MessageView.swift
//  Dorgu
//
//  Created by 이돈혁 on 1/27/26.
//

import SwiftUI

struct MessageView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextEditor(text: .constant(""))
                    .frame(minHeight: 200)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3))
                    )

                Button("분석") {
                    // TODO: 스미싱 / 보이스피싱 분석 로직 연결
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
            .navigationTitle("메시지")
        }
    }
}
