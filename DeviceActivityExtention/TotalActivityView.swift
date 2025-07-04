import SwiftUI
import ManagedSettings
import DeviceActivity
import Charts

struct TotalActivityView: View {
    let contextLabel: String
    let totalActivity: TotalActivityModel
    
    @State private var categoryDurations: [String: Int] = [:] // ← 表示用の辞書
    
    @State private var tap : Bool = false

    var body: some View {
        VStack {
            ZStack {
                switch contextLabel {
                case "barGraph":
                    switch totalActivity.segmentInterval {
                    case .hourly:
                        Chart(totalActivity.durations, id: \.dateInterval.start) { segment in
                            BarMark(
                                x: .value("Time", segment.dateInterval.start, unit: .hour),
                                y: .value("Duration (min)", segment.duration / 60)
                            )
                        }
                        .chartXAxisLabel("時間")
                        .chartYAxisLabel("使用時間（分）")
                        .frame(height: 300)
                        
                    case .daily:
                        Chart(totalActivity.durations, id: \.dateInterval.start) { segment in
                            BarMark(
                                x: .value("Date", segment.dateInterval.start, unit: .day),
                                y: .value("Duration (min)", segment.duration / 60)
                            )
                        }
                        .chartXAxisLabel("日付")
                        .chartYAxisLabel("使用時間（分）")
                        .frame(height: 300)
                        
                    case .weekly:
                        Chart(totalActivity.durations, id: \.dateInterval.start) { segment in
                            BarMark(
                                x: .value("Week", segment.dateInterval.start, unit: .weekOfYear),
                                y: .value("Duration (min)", segment.duration / 60)
                            )
                        }
                        .chartXAxisLabel("週")
                        .chartYAxisLabel("使用時間（分）")
                        .frame(height: 300)
                        
                    @unknown default:
                        Text("未対応の時間区切りです")
                    }
                default:
                    Text("不明なグラフ形式です")
                }
                
                if tap {
                    List(categoryDurations.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        HStack {
                            Text(key)
                            Spacer()
                            Text("\(value) 分")
                        }
                    }
                }
                
                
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .onTapGesture {
                        tap.toggle()
                    }
            }
        }
        .padding()
        .onAppear {
            Task {
                var totals: [String: Int] = [:]

                for duration in totalActivity.durations {
                    for try await categoryActivity in duration.category {
                        // カテゴリ名（例："Games", "Education"）
                        let name = getJapaneseCategoryName(from: categoryActivity.category.localizedDisplayName ?? "不明")
                        // 秒→分に変換して Int に丸める
                        let minutes = Int(categoryActivity.totalActivityDuration / 60)

                        totals[name, default: 0] += minutes
                    }
                }

                categoryDurations = totals
            }
        }
    }
}

func getJapaneseCategoryName(from localizedName: String) -> String {
    switch localizedName {
    case "Education":
        return "教育"
    case "Social":
        return "SNS"
    case "Games":
        return "ゲーム"
    case "Entertainment":
        return "エンターテインメント"
    case "Productivity & Finance":
        return "仕事効率化とファイナンス"
    case "Creativity":
        return "クリエイティビティ"
    case "Information & Reading":
        return "情報と読書"
    case "Health & Fitness":
        return "健康とフィットネス"
    case "Shopping & Food":
        return "ショッピングとフード"
    case "Utilities":
        return "ユーティリティ"
    case "Travel":
        return "旅行"
    case "Other":
        return "その他"
    default:
        return localizedName // 不明な場合はそのまま返す
    }
}
