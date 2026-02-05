//
//  ReportView.swift
//  Dorgu
//
//  Created by 이돈혁 on 1/27/26.
//

import SwiftUI

struct ReportView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    Text("누르고 바로 신고하세요")
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(y: -20)
                ZStack(alignment: .leading) {
                    Image("OnlineSingo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .offset(x: -20, y: 0)
                        .zIndex(1)
                    Button {
                        if let url = URL(string: "https://ecrm.police.go.kr/sci/pcc_V3_send?rp=r") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("온라인 신고하기 (사이버범죄 신고시스템)")
                            .font(.callout)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .zIndex(0)
                }
                ZStack(alignment: .leading) {
                    Image("Police")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .offset(x: -20, y: 0)
                        .zIndex(1)
                    Button {
                        if let url = URL(string: "tel://112") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("피싱 / 보이스피싱 신고하기 (경찰청)")
                            .font(.callout)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .zIndex(0)
                }
                ZStack(alignment: .leading) {
                    Image("KISA")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .offset(x: -20, y: 0)
                        .zIndex(1)
                    Button {
                        if let url = URL(string: "tel://118") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("스미싱 / 문자 / 악성 앱 신고하기 (한국인터넷진흥원)")
                            .font(.callout)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .zIndex(0)
                }
                ZStack(alignment: .leading) {
                    Image("GGW")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .offset(x: -20, y: 0)
                        .zIndex(1)
                    Button {
                        if let url = URL(string: "tel://1332") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("금융피해 신고하기 (금융감독원)")
                            .font(.callout)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .zIndex(0)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .offset(y: -100)
            .navigationTitle("온라인, 유선 신고")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
