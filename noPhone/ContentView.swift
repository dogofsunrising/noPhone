//
//  ContentView.swift
//  noPhone
//
//  Created by 藤本皇汰 on 2024/11/29.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onChange(of: scenePhase) {
                    if scenePhase == .background {
                        print("バックグラウンド（.background）")
                    }
                    if scenePhase == .active {
                        print("フォアグラウンド（.active）")
                    }
                    if scenePhase == .inactive {
                        print("バックグラウンドorフォアグラウンド直前（.inactive）")
                    }
                }
    }
}

