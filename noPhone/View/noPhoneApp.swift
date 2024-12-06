import SwiftUI

@main
struct noPhoneApp: App {
    @State var Screen:Screen = .start
    var body: some Scene {
        WindowGroup {
            
            switch Screen {
            case .start:
                StartView(Screen: $Screen)
            case .stop:
                StopView(Screen: $Screen)
            case .timer:
                TimerView(Screen: $Screen)
            }
            
        }
    }
}
