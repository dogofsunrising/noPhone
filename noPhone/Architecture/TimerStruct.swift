import SwiftUI

struct TimerItem: Identifiable {
    let id = UUID()
    let timer: String // タイマー名や情報
    var isExpanded: Bool = false // 展開状態
}
