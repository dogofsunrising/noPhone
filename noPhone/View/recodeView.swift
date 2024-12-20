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
                            List{
                                if graph {
                                    withAnimation {
                                        LineView(recodeTimeList: recodeTimeList)
                                            .transition(.move(edge: .bottom).combined(with: .opacity)) // 下からフェードイン
                                    }
                                }
                                
                                ForEach(recodeTimeList.indices, id: \.self) { index in
                                    Section{
                                        VStack{
                                            HStack{
                                                Spacer()
                                                Text(formattedDate(date: recodeTimeList[index].date))
                                                    .font(.title3)
                                                
                                                Spacer()
                                                if recodeTimeList[index].close {
                                                    Text("Success")
                                                        .font(.title2)
                                                        .foregroundColor(.blue)
                                                } else {
                                                    Text("Failed")
                                                        .font(.title)
                                                        .foregroundColor(.red)
                                                }
                                                Spacer()
                                                
                                            }
                                            HStack {
                                                Image(systemName: "timer") // アイコン
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                RecoTimer(timer: recodeTimeList[index].settingtime, close: recodeTimeList[index].close,on:false)
                                                Spacer()
                                                Image(systemName: "person.badge.clock") // アイコン
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                
                                                RecoTimer(timer: recodeTimeList[index].realtime, close: recodeTimeList[index].close,on:true)
                                                Spacer()
                                            }
                                        }.padding(.vertical, 8)
                                            .listRowBackground(recodeTimeList[index].close == true ? ButtonColor : lightPink)
                                    }
                                }
                            }
                            .scrollContentBackground(.hidden)
                            .background(GradientBackgroundView())
                            .scrollIndicators(.hidden)
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
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // カスタムフォーマット
        return formatter.string(from: date)
    }
}

