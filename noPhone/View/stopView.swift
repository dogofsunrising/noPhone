import SwiftUI
import CoreMotion

struct StopView : View {
    @Environment(\.scenePhase) private var scenePhase
    
    @Binding var Screen: Screen
    
    @State var Moniter: Bool = true
    
    @State private var AlertType:AlertType? = nil
    @State private var showAlert: Bool = false
    
    @State private var channelid: String = ""
    @State private var username: String = ""
    @State private var time: Int = 0
    @State private var initimer:Int = 0
    @State private var timerActive: Bool = false // タイマーが動作中かどうか
    @State var timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
        
    @State var popmess:String = ""
    
    private let motionManager = CMMotionManager()
    @State private var core_x: Double = 0.0
    @State private var core_y: Double = 0.0
    @State private var core_z: Double = 0.0
    @State private var core  : Bool = true
    
    var body: some View {
        ZStack{
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
            if(!Moniter){
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                LoadingAlert()
            }
        }
        .onAppear {
            channelid = UserDefaults.standard.string(forKey: "channelid") ?? ""
            username = UserDefaults.standard.string(forKey: "username") ?? ""
            time = UserDefaults.standard.integer(forKey: "selectedTimer")
            initimer = time
            if(time != 0){
                timerActive = true
            }else{
                timerActive = false
            }
            
            start()
        }
        .onDisappear {
            timerActive = false // タイマーを停止
        }
        .onReceive(timer) { _ in
            if(timerActive){
                time -= 1
                if(time == 0){
                    Moniter = false
                    timerActive = false
                    Task{
                        await Report(channelid: channelid, name: username, realtime: time, close: true,inittime: initimer)
                    }
                    
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
                    await Report(channelid: channelid, name: username, realtime: time, close: false,inittime: initimer)
                }
                
            }
        }
        .alert(isPresented: $showAlert) {
            switch AlertType {
            case .miss:
                Alert(
                    title: Text("終了します"),
                    message: Text(popmess),
                    dismissButton: .default(Text("OK"),action: {
                        Screen = .start
                    })
                )
            case .finish:
                Alert(
                    title: Text("おめでとう！"),
                    message: Text(popmess),
                    dismissButton: .default(Text("OK"),action: {
                        Task{
                            Screen = .start
                        }
                    })
                )
            case nil:
                Alert(title: Text("エラー"))
            }
            
        }
        
    }
    
    
    private func Report(channelid: String, name: String, realtime: Int, close: Bool, inittime: Int) async {
        let realtime = inittime - realtime
        let reporter = API(channelid: channelid, name: name, time: realtime, close: close)
        if let message = await reporter.postAPI() {
            popmess = message
            if(close){
                popmess = message
                AlertType = .finish
            } else{
                popmess = message
                AlertType = .miss
            }
            Moniter = true
            showAlert = true
        } else {
            if(close){
                popmess = "おめでとうございます"
                AlertType = .finish
            } else{
                popmess = "封印しましょう"
                AlertType = .miss
            }
            Moniter = true
            showAlert = true
        }
        
        
    }
    
    
    private func start() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.5
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                guard let data else { return }
                core_x = data.acceleration.x
                core_y = data.acceleration.y
                core_z = data.acceleration.z
                core = (core_x == 0 || core_y == 0 || core_z == 0)
            }
        }
    }
}
