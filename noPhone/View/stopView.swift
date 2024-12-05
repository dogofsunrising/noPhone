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
            //フォアグラウンドに戻った時の処理
            if scenePhase == .active {
                Moniter = true
            }
            // バックグラウンドに行った時の処理
            if (scenePhase == .inactive && Moniter){
                Moniter = false
                Task{
                    await Report()
                }
                
            }
        }
    }
    
    private func Report() async {
        print("バックグラウンドorフォアグラウンド直前（.inactive）")
        let reporter = API(channelid: "1311228113602215988", name: "犬柴Mobile")
        
        reporter.postAPI()
    }
}
