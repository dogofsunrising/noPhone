import SwiftUI

struct StopView : View {
    @Environment(\.scenePhase) private var scenePhase
    
    @Binding var isWaiting: Bool
    
    @State var Moniter: Bool = true
    init(isWaiting: Binding<Bool>) {
        self._isWaiting = isWaiting
    }

    var body: some View {
        VStack {
            Button {
                isWaiting.toggle()
            } label: {
                Text("Stop")
            }
        }
        .onChange(of: scenePhase) {
                    
                    if scenePhase == .active {
                        Moniter = true
                    }
                    if (scenePhase == .inactive && Moniter){
                        Moniter = false
                        print("バックグラウンドorフォアグラウンド直前（.inactive）")
                    }
                }
    }
}
