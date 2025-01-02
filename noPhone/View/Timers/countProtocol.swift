import SwiftUI

@MainActor
public protocol Count: View {
    /// プロパティの型を定義する
    var timer: Int { get set }
    var hours: Int { get set }
    var minutes: Int { get set }
    var seconds: Int { get set }
    /// イニシャライザを定義する
    init(timer:Int)
}

