import SwiftUI

struct RecodeView: View {
    @Binding var Screen: Screen
    @State private var recodeTimeList: [recodeModel] = []
    
    @State private var graph:Bool = true
    var body: some View {
        NavigationView {
            
                ZStack{
                    
                    VStack {
                        if recodeTimeList.isEmpty {
                            Text("記録が空です")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            RecoListView(recodeTimeList: recodeTimeList, graph: $graph)
                            
                        }
                    }
                
            }
            .onAppear(perform: {
                recodeTimeList = loadRecodeListFromDefaults()
            })
            .navigationBarTitle("記録", displayMode: .inline)
            .navigationBarItems(
                leading: Button("戻る", action: onBackButtonPressed),
                trailing: Button(action: {
                    withAnimation {
                        graph.toggle()
                    }
                }) {
                    if graph {
                        Text("グラフを閉じる")
                    } else {
                        Text("グラフを表示")
                    }
                }
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

