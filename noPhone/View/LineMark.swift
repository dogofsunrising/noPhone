import SwiftUI
import Charts
struct LineView: View {
    
   let recodeTimeList: [recodeModel]
    
    var body: some View {
            VStack{
                if(recodeTimeList.isEmpty){
                    Text("記録はありません")
                }else{
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal) {  // 横スクロールを有効にする
                            Chart(recodeTimeList) { index in
                                LineMark(x: .value("Id", index.num), y: .value("Time", index.realtime))
                                    .foregroundStyle(.black)
                                
                                if index.close {
                                    PointMark(x: .value("Id", index.num), y: .value("Time", index.realtime))
                                        .foregroundStyle(.blue)
                                } else {
                                    PointMark(x: .value("Id", index.num), y: .value("Time", index.realtime))
                                        .foregroundStyle(.red)
                                }
                            }
                            .frame(minWidth: 1000) // 横方向のグラフの幅を調整
                            .padding()
                            .onAppear {
                                proxy.scrollTo(0)
                            }
                        }
                    }
                }
            } .frame(height: 300)
        
    }
}
