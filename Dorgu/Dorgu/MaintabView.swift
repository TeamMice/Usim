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
                UsimView()
            }
            .tabItem {
                Label("으심대", systemImage: "magnifyingglass")
            }
            
            NavigationStack {
                ReportView()
            }
            .tabItem {
                Label("신고", systemImage: "light.beacon.max.fill")
            }
        }
    }
}

