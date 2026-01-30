//
//  MessageView.swift
//  Dorgu
//
//  Created by 이돈혁 on 1/27/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    Text("스미싱 예방법")
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
                    Image("HomeNo1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .offset(x: -20, y: -12)
                    Text("불분명한 송신자가 보낸 URL 클릭하지 말기")
                        .font(.callout)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
                ZStack(alignment: .leading) {
                    Image("HomeNo2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .offset(x: -20, y: -24)
                    Text("의심스러운 전화는 일단 끊고, 해당 기관에 직접 전화하기")
                        .font(.callout)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
                ZStack(alignment: .leading) {
                    Image("HomeNo3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .offset(x: -20, y: -12)
                    Text("업무, 일상에 불필요한 국제 발진 문자 수신 차단하기")
                        .font(.callout)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
                ZStack(alignment: .leading) {
                    Image("HomeNo4")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .offset(x: -20, y: -24)
                    Text("스마트폰 보안 제품 설치하기 (ex. V3 모바일 시큐리티, 후후 등)")
                        .font(.callout)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .offset(y: -100)
            .navigationTitle("으심대")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
