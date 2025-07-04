//
//  TotalActivityReport.swift
//  report_test
//
//  Created by 藤本皇汰 on 2025/07/03.
//

import DeviceActivity
import SwiftUI
import OSLog
import ManagedSettings

extension DeviceActivityReport.Context {
    // If your app initializes a DeviceActivityReport with this context, then the system will use
    // your extension's corresponding DeviceActivityReportScene to render the contents of the
    // report.
    static let barGraph = Self("barGraph")
}

struct TotalActivityReport: DeviceActivityReportScene {
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context
    
    // Define the custom configuration and the resulting view for this report.
    let content: (TotalActivityModel) -> TotalActivityView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> TotalActivityModel {
        // Reformat the data into a configuration that can be used to create
        // the report's view.
        
        var firstData: DeviceActivityData?
        for await item in data {
            firstData = item
        }
        
        var segmentInterval = (firstData?.segmentInterval)!
        
        var Intervals: [durationModel] = []
        if let segments = firstData?.activitySegments {
            for await segment in segments {
                Intervals.append(durationModel(duration: segment.totalActivityDuration, dateInterval: segment.dateInterval, longestActivity: segment.longestActivity, category: segment.categories))
            }
        }
        return TotalActivityModel(segmentInterval: segmentInterval, durations: Intervals)
    }
}

struct TotalActivityModel {
    var segmentInterval: DeviceActivityFilter.SegmentInterval
    var durations: [durationModel]
}

struct durationModel {
    var duration: TimeInterval
    var dateInterval: DateInterval
    var longestActivity: DateInterval?
    var category: DeviceActivityResults<DeviceActivityData.CategoryActivity>
}

