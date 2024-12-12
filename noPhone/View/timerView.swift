import SwiftUI

struct TimerView: View {
    @Binding var Screen: Screen
    @State var timerList: [Int] = [797401, 4791, 321, 2, 481] // Int型のリスト
    @State private var selectedTimerIndex: Int? = nil // 選択されているタイマーのインデックス

    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    if timerList.isEmpty {
                        Text("タイマーリストが空です")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(timerList.indices, id: \.self) { index in
                            HStack {
                                WhatTimer(timer: timerList[index])
                                Spacer()
                                Toggle("", isOn: Binding(
                                    get: {
                                        selectedTimerIndex == index
                                    },
                                    set: { isOn in
                                        if isOn {
                                            selectedTimerIndex = index
                                        } else {
                                            selectedTimerIndex = nil
                                        }
                                    }
                                ))
                                .toggleStyle(SwitchToggleStyle(tint: .blue))
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
                .onAppear {
                    loadSelectedTimer() // 保存されたタイマーをロード
                }
            }
            .padding()
            .navigationBarTitle("タイマー選択", displayMode: .inline)
            .navigationBarItems(leading: Button("戻る", action: onBackButtonPressed))
        }
    }

    // 選択されたタイマーを保存する関数
    private func saveSelectedTimer() {
        let selectedTimer = selectedTimerIndex != nil ? timerList[selectedTimerIndex!] : 0
        UserDefaults.standard.set(selectedTimer, forKey: "selectedTimer")
        Screen = .start
    }

    // 保存されたタイマーをロードする関数
      private func loadSelectedTimer() {
          let savedTimer = UserDefaults.standard.integer(forKey: "selectedTimer")
          if let index = timerList.firstIndex(of: savedTimer) {
              selectedTimerIndex = index
          } else {
              selectedTimerIndex = nil
          }
      }
    
    // 戻るボタンが押されたときに実行される関数
    private func onBackButtonPressed() {
        Screen = .start
        saveSelectedTimer()
    }
}
