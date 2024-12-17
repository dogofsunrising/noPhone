import SwiftUI

struct recodeModel : Codable{
    let date: Date
    let realtime: Int // タイマー名や情報
    let settingtime: Int // タイマー名や情報
    let close:Bool
}
