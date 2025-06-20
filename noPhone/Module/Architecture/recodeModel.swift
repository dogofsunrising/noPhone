import SwiftUI
import Charts
struct recodeModel : Codable, Identifiable{
    var id = UUID()
    let num : Int
    let date: Date
    let realtime: Int // タイマー名や情報
    let settingtime: Int // タイマー名や情報
    let close:Bool
    let title:String
}
