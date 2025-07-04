//
//  DeviceActivityExtention.swift
//  DeviceActivityExtention
//
//  Created by 藤本皇汰 on 2025/07/05.
//

import DeviceActivity
import SwiftUI

@main
struct report_test: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // 棒グラフ表示用レポート
        TotalActivityReport(context: .barGraph) { totalActivity in
            TotalActivityView(contextLabel: "barGraph", totalActivity: totalActivity)
        }
    }
}
