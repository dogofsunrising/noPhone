import SwiftUI

struct RecoListView: View {
    @State private var recodeTimeList: [recodeModel]
    @Binding var graph:Bool
    init(recodeTimeList: [recodeModel], graph: Binding<Bool>) {
        _recodeTimeList = State(initialValue: recodeTimeList)
        _graph = graph
    }
    var body: some View {
        VStack {
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
                                
                                Text(recodeTimeList[index].title)
                                    .font(.title2)
                                    .foregroundColor(recodeTimeList[index].close ? .blue : .red)
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
                                if recodeTimeList[index].close {
                                    Text("Success")
                                } else {
                                    Text("Failed")
                                }
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
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // カスタムフォーマット
        return formatter.string(from: date)
    }
}
