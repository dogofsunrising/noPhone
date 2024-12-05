import SwiftUI

@main
struct noPhoneApp: App {
    @State var isWaiting = true
    var body: some Scene {
        WindowGroup {
            
            if isWaiting { StartView(isWaiting: $isWaiting) } else { StopView(isWaiting: $isWaiting) }
            
        }
    }
}
