//
//  MaintabView.swift
//  Dorgu
//
//  Created by 이돈혁 on 1/27/26.
//

import SwiftUI

struct MaintabView: View {
    var body: some View {
        TabView {
            MessageView()
                .tabItem {
                    Label("메시지", systemImage: "message")
                }

            CameraView()
                .tabItem {
                    Label("카메라", systemImage: "camera")
                }
        }
    }
}

#Preview {
    MaintabView()
}
