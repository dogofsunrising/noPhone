import SwiftUI

@main
struct noPhoneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var Screen:Int = 0
    @State private var Ad: Bool = false
    @State private var stop:Bool = false
    var body: some Scene {
        WindowGroup {
            ZStack{
                if(stop){
                    StopView(Ad: $Ad, stop: $stop)
                } else {
                    // BannerContentView(navigationTitle: "Banner")
                    TabView(selection: $Screen) {
                        HomeView(stopTimer: $stop)
                            .tag(0)
                            .tabItem {
                                Label("Home", systemImage: "lock.fill")
                            }
                        TodoView()
                            .tag(1)
                            .tabItem {
                                Label("ToDo", systemImage: "lock.doc")
                            }
                        MoniterView()
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
            .animation(.easeInOut(duration: 0.5), value: stop)
            .animation(.easeInOut(duration: 0.5), value: Screen)
        }
    }
}
