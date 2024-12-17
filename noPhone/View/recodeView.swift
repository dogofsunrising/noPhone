import SwiftUI

struct RecodeView: View {
    @Binding var Screen: Screen
    @State private var recodeTimeList: [recodeModel] = []
    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    if recodeTimeList.isEmpty {
                        Text("記録が空です")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        List{
                            ForEach(recodeTimeList.indices, id: \.self) { index in
                                HStack {
                                    WhatTimer(timer: recodeTimeList[index].realtime)
                                    Spacer()
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .listStyle(.plain)
                        .scrollIndicators(.hidden)
                    }
                }
            }
            .onAppear(perform: {
                recodeTimeList = loadRecodeListFromDefaults()
            })
            .padding()
            .navigationBarTitle("記録", displayMode: .inline)
            .navigationBarItems(
                leading: Button("戻る", action: onBackButtonPressed)
            )
        }
    }
    // 戻るボタンが押されたときに実行される関数
    private func onBackButtonPressed() {
        Screen = .start
    }
    
    private func loadRecodeListFromDefaults() -> [recodeModel] {
        if let savedData = UserDefaults.standard.data(forKey: "recodelist"),
           let decoded = try? JSONDecoder().decode([recodeModel].self, from: savedData) {
            return Array(decoded.reversed()) // ここで順番を逆にする
        }
        return []
    }
}

