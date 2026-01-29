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
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("홈", systemImage: "house")
            }

            NavigationStack {
                UsimView()
            }
            .tabItem {
                Label("으심대", systemImage: "magnifyingglass")
            }
        }
    }
}

