import SwiftUI

@main
struct noPhoneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var Screen:Screen = .start
    @State private var Ad: Bool = false
    var body: some Scene {
        WindowGroup {
            ZStack {
                GradientBackgroundView()
                if Screen == .start {
                    StartView(Screen: $Screen)
                       
                } else if Screen == .stop {
                    StopView(Screen: $Screen, Ad: $Ad)
                        
                } else if Screen == .recode {
                    RecodeView(Screen: $Screen)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: Screen)
        }
    }
}
