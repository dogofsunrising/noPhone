import SwiftUI

struct TimerView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var timerList: [Int] = [] // Int型のリスト
    @State private var selectedTimerIndex: Int? = nil // 選択されているタイマーのインデックス
    @State private var showAddTimerSheet: Bool = false
    
    @Binding var showAlert: Bool
    @Binding var delete: DeleteType
    @Binding var time:Int
    @State private var pendingIndex: Int? = nil
    var body: some View {
            ZStack{
                VStack {
                    List{
                        ForEach(timerList.indices, id: \.self) { index in
                            Section {
                                VStack{
                                    Button(action: {
                                        pendingIndex = index
                                        showAlert = true
                                        delete = .load
                                    }) {
                                        HStack {
                                            SubTimer(timer: timerList[index], screenHeight: UIScreen.main.bounds.height)
                                            
                                            
                                            
                                            
                                            Toggle("", isOn: Binding(
                                                get: {
                                                    selectedTimerIndex == index
                                                },
                                                set: { isOn in
                                                    if isOn {
                                                        selectedTimerIndex = index
                                                        time = timerList[index]
                                                        
                                                    } else {
                                                        selectedTimerIndex = nil
                                                        time = 0
                                                    }
                                                    saveSelectedTimer()
                                                }
                                            ))
                                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                                        }
                                        .padding(.vertical, 7)
                                    }
                                }
                                .listRowBackground(ButtonColor(how: .button, scheme: colorScheme))
                                .listRowSeparatorTint(ButtonColor(how: .text, scheme: colorScheme))
                            }
                            
                            
                        }
                        HStack{
                            Spacer()
                            Button(action: {
                                showAddTimerSheet = true
                            }) {
                                Image(systemName: "plus") // 歯車アイコン
                                    .resizable() // サイズを変更可能にする
                                    .frame(width: 30, height: 30) // 幅と高さを指定
                            }
                            Spacer()
                        }.listRowBackground(ButtonColor(how: .button, scheme: colorScheme))
                    }
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .listSectionSpacing(5)
                    .scrollIndicators(.hidden)
                }
                VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.black.opacity(0.2))
                            .frame(height: 50)
                            .blur(radius: 10)
                            .offset(y: 10) // 影を少し下にずらす
                    }
                .onChange(of: delete) {
                    Task{
                        if(delete == .yes){
                            if let index = pendingIndex { // 削除予定のインデックスを確認
                                removeTimer(at: index)
                            }
                            delete = .non
                        }
                    }
                }
                .onAppear {
                    initTimer() //ローカルのタイマーをリストか
                    loadSelectedTimer() // 保存されたタイマーをロード
                }
            }
            .scrollContentBackground(.hidden)
            .background(.opacity(0))
            .sheet(isPresented: $showAddTimerSheet) {
                AddTimerView(isPresented: $showAddTimerSheet, timerList: $timerList)
            }
    }

    // 選択されたタイマーを保存する関数
    private func saveSelectedTimer() {
        let selectedTimer = selectedTimerIndex != nil ? timerList[selectedTimerIndex!] : 0
        UserDefaults.standard.set(selectedTimer, forKey: "selectedTimer")
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
