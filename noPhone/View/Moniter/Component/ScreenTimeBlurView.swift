import SwiftUI
import FamilyControls
import DeviceActivity
import ManagedSettings

extension DeviceActivityReport.Context {
    static let barGraph = Self("barGraph")
}

struct ScScreenTimeBlurView: View {
    let context: DeviceActivityReport.Context = .barGraph

    @State private var selectedSegment: DeviceActivityFilter.SegmentInterval = .daily(
        during: Calendar.current.dateInterval(of: .weekOfYear, for: .now)!
    )
    
    @State private var filter: DeviceActivityFilter = .init()
    @State private var reportID = UUID()
    @State private var isReportVisible: Bool = true

    var body: some View {
        VStack {
            if isReportVisible {
                DeviceActivityReport(context, filter: filter)
                    .id(reportID)
            } else {
                Spacer()
                ProgressView()
                    .frame(width: 300, height: 300)
            }
        }
        .onAppear {
            regenerateReport()
        }
    }

    func regenerateReport() {
        // セグメントに基づくフィルタを再生成
        filter = DeviceActivityFilter(
            segment: selectedSegment,
            users: .all,
            devices: .init([.iPhone, .iPad])
        )

        // 一旦非表示にしてから再表示（onAppear再発火させる）
        isReportVisible = false
        DispatchQueue.main.async {
//            reportID = UUID() // 強制的にViewのidentityを変える
            isReportVisible = true
        }
    }
}

