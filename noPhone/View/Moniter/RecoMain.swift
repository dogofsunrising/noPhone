import SwiftUI

struct RecoMainView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var recodeTimeList: [recodeModel] = []
    @Binding var isRecode: Bool
    @State private var graph:Bool = true
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    LineView(recodeTimeList: recodeTimeList)
                    VStack {
                        Button(action: {
                            isRecode = true
                        }) {
                            Text("全ての履歴の表示")
                        }
                        if recodeTimeList.isEmpty {
                            Text("記録が空です")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(recodeTimeList.indices.prefix(3), id: \.self) { index in
                                Section{
                                    VStack{
                                        HStack{
                                            Spacer()
                                            
                                            Text(recodeTimeList[index].title)
                                                .foregroundColor(recodeTimeList[index].close ? .blue : .red)
                                            Spacer()
                                            
                                        }
                                        HStack {
                                            Spacer()
                                            Image(systemName: "person.badge.clock") // アイコン
                                                .resizable()
                                                .frame(width: 10, height: 10)
                                            
                                            RecoTimer(timer: recodeTimeList[index].realtime, close: recodeTimeList[index].close,on:true)
                                            Spacer()
                                        }
                                    }.padding(.vertical, 8)
                                        .listRowBackground(recodeTimeList[index].close == true ? ButtonColor(how: .button, scheme: colorScheme) : lightPink)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .onAppear(perform: {
            recodeTimeList = loadRecodeListFromDefaults()
        })
        .navigationBarTitle("Moniter", displayMode: .inline)
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
