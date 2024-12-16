import SwiftUI

struct TimerView: View {
    @Binding var Screen: Screen
    @State var timerList: [Int] = [] // Int型のリスト
    @State private var selectedTimerIndex: Int? = nil // 選択されているタイマーのインデックス
    @State private var showAddTimerSheet: Bool = false

    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    if timerList.isEmpty {
                        Text("タイマーリストが空です")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        List{
                            ForEach(timerList.indices, id: \.self) { index in
                                HStack {
                                    WhatTimer(timer: timerList[index])
                                    Spacer()
                                    Button(action: {
                                        removeTimer(at: index)
                                    }) {
                                        Image(systemName: "trash")
                                        
                                    }
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
                        .listStyle(.plain)
                        .scrollIndicators(.hidden)
                    }
                }
                .onAppear {
                    initTimer() //ローカルのタイマーをリストか
                    loadSelectedTimer() // 保存されたタイマーをロード
                }
            }
            .padding()
            .navigationBarTitle("タイマー選択", displayMode: .inline)
            .navigationBarItems(
                leading: Button("戻る", action: onBackButtonPressed),
                trailing: Button(action: {
                    showAddTimerSheet = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                }
            )
            .sheet(isPresented: $showAddTimerSheet) {
                AddTimerView(isPresented: $showAddTimerSheet, timerList: $timerList)
            }
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
    
    private func initTimer() {
        timerList = UserDefaults.standard.array(forKey: "timerList") as? [Int] ?? []
    }
    
    private func removeTimer(at index: Int) {
        guard index >= 0 && index < timerList.count else { return } // 安全に範囲を確認
        timerList.remove(at: index)
        saveTimer()
    }
    
    // タイマーを保存する関数
    private func saveTimer() {
        UserDefaults.standard.set(timerList, forKey: "timerList")
    }
}
