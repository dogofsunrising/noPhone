import SwiftUI
import FamilyControls
import DeviceActivity
import ManagedSettings


extension DeviceActivityReport.Context {
    static let barGraph = Self("barGraph")
}

struct ScScreenTimeBlurView: View {
    @State var context: DeviceActivityReport.Context = .barGraph
    @State private var filter: DeviceActivityFilter = .init()
    @State private var selectedSegment: DeviceActivityFilter.SegmentInterval = .daily(
        during: Calendar.current.dateInterval(of: .weekOfYear, for: .now)!
    )
    @State private var reportID = UUID()
    @State private var isReportVisible: Bool = false
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Reload") {
                    reportID = UUID()
                }
            }
            DeviceActivityReport(context, filter: filter)
                .id(reportID)
                .onAppear {
                    isReportVisible = true
                    print("レポート表示開始")
                    print("\(context)")
                    print("\(filter)")
                    
                }
                .onDisappear {
                    isReportVisible = false
                    print("レポート表示終了")
                }
        }
        .onAppear {
            regenerateReport()
        }
    }
    
    func regenerateReport() {
        filter = DeviceActivityFilter(
            segment: selectedSegment,
            users: .all,
            devices: .init([.iPhone, .iPad])
        )
        DispatchQueue.main.async {
               reportID = UUID() // 確実に描画更新
           }
    }
}
