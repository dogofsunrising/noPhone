import SwiftUI

struct StopView : View {
    @Environment(\.scenePhase) private var scenePhase
    
    @Binding var Screen: Screen
    
    @State var Moniter: Bool = true

    var body: some View {
        VStack {
            Button {
                Screen = .start
            } label: {
                ZStack{
                    Rectangle()
                        .foregroundColor(.blue)
                        .frame(width: 200, height: 200)
                    Text("Stop")
                        .foregroundColor(.white)
                }
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
        let reporter = API(channelid: "1311228113602215988", name: "Alomafire")
        
        reporter.postAPI()
    }
}
