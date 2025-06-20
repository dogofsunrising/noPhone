import SwiftUI

@main
struct noPhoneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var Screen:Int = 0
    @State private var Ad: Bool = false
    var body: some Scene {
        WindowGroup {
            ZStack {
//                GradientBackgroundView()
                VStack{
//                    BannerContentView(navigationTitle: "Banner")
                    TabView(selection: $Screen) {
                        HomeView()
                            .tag(0)
                            .tabItem {
                                Label("Home", systemImage: "lock.fill")
                            }
                        SettingView()
                            .tag(1)
                            .tabItem {
                                Label("ToDo", systemImage: "lock.doc")
                            }
                        RecodeView()
                            .tag(2)
                            .tabItem {
                                Label("Moniter", systemImage: "lock.laptopcomputer")
                            }
                        SettingView()
                            .tag(3)
                            .tabItem {
                                Label("Setting", systemImage: "gearshape.fill")
                            }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.5), value: Screen)
        }
    }
}
