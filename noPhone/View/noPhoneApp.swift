import SwiftUI

@main
struct noPhoneApp: App {
    @State var Screen:Screen = .start
    @State private var showView: Bool = true // フェードアウト制御用
    var body: some Scene {
        WindowGroup {
            ZStack {
                if Screen == .start {
                    StartView(Screen: $Screen)
                       
                } else if Screen == .stop {
                    StopView(Screen: $Screen)
                       
                } else if Screen == .timer {
                    TimerView(Screen: $Screen)
                        
                }
            }
            .animation(.easeInOut(duration: 0.5), value: Screen)
        }
    }
}
