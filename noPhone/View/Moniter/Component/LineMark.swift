import SwiftUI
import Charts

struct LineView: View {
    let recodeTimeList: [recodeModel]

    // 最新の10件を取得（要素数が10未満ならそのまま）
    var latestTen: [recodeModel] {
        Array(recodeTimeList.suffix(15))
    }

    var body: some View {
        VStack {
            if latestTen.isEmpty {
                Text("記録はありません")
            } else {
                Chart(latestTen) { index in
                    LineMark(x: .value("Id", index.num), y: .value("Time", index.realtime))
                        .foregroundStyle(.green)

                    PointMark(x: .value("Id", index.num), y: .value("Time", index.realtime))
                        .foregroundStyle(index.close ? .blue : .red)
                }
                .padding()
            }
        }
        .frame(height: 300)
    }
}

