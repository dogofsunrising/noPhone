import SwiftUI

struct StopView : View {
    @Environment(\.scenePhase) private var scenePhase
    
    @Binding var Screen: Screen
    
    @State var Moniter: Bool = true
    
    @State private var AlertType:AlertType? = nil
    @State private var showAlert: Bool = false
    
    @State private var channelid: String = ""
    @State private var username: String = ""
    @State private var time: Int = 0
    
    @State private var timerActive: Bool = false // タイマーが動作中かどうか
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
        

    var body: some View {
        VStack {
            WhatTimer(timer: time)
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
        .onAppear {
            channelid = UserDefaults.standard.string(forKey: "channelid") ?? ""
            username = UserDefaults.standard.string(forKey: "username") ?? ""
            time = UserDefaults.standard.integer(forKey: "selectedTimer")
            if(time != 0){
                timerActive = true
            }else{
                timerActive = false
            }
        }
        .onDisappear {
            timerActive = false // タイマーを停止
        }
        .onReceive(timer) { _ in
            if(timerActive){
                time -= 1
                if(time == 0){
                    timerActive = false
                    showAlert = true
                    AlertType = .finish
                    
                }
            }
            
        }
        .onChange(of: scenePhase) {
//            //フォアグラウンドに戻った時の処理
//            if scenePhase == .active {
//                Moniter = true
//                timerActive = true
//            }
            // バックグラウンドに行った時の処理
            if (scenePhase == .inactive && Moniter){
                Moniter = false
                timerActive = false
                Task{
                    await Report(channelid: channelid, name: username)
                }
                
            }
        }
        .alert(isPresented: $showAlert) {
            switch AlertType {
            case .miss:
                Alert(
                    title: Text("終了します"),
                    message: Text("スマホを封印しましょう"),
                    dismissButton: .default(Text("OK"),action: {
                        Screen = .start
                    })
                )
            case .finish:
                Alert(
                    title: Text("おめでとう！"),
                    message: Text("タイマーが終了しました"),
                    dismissButton: .default(Text("OK"),action: {
                        Screen = .start
                    })
                )
            case nil:
                Alert(title: Text("エラー"))
            }
            
        }
        
    }
    
    
    private func Report(channelid:String, name:String) async {
        let reporter = API(channelid: channelid, name: name)
        showAlert = true
        AlertType = .miss
        reporter.postAPI()
    }
    
    
}
