import SwiftUI
import CoreMotion

struct StopView : View {
    @Environment(\.scenePhase) private var scenePhase
    
    @Binding var Screen: Screen
    
    @State var Moniter: Bool = true
    
    @State private var AlertType:AlertType? = nil
    @State private var showAlert: Bool = false
    @State private var isInBackground = false
    
    @State private var channelid: String = ""
    @State private var username: String = ""
    @State private var time: Int = 0
    @State private var initimer:Int = 0
    @State private var timerActive: Bool = false
    @State private var countup:Bool = false
    @State var timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
        
    @State var popmess:String = ""
    
    private let motionManager = CMMotionManager()
    @State private var core_x: Double = 0.0
    @State private var core_y: Double = 0.0
    @State private var core_z: Double = 0.0
    
    @State private var inicore_x: Double = 0.0
    @State private var inicore_y: Double = 0.0
    @State private var inicore_z: Double = 0.0
    
    @State private var core  : Bool = false
    
    
    //タイマー保存
    @State private var date: Date = Date()
    
    @State private var end:Bool = false
    
    let musicplayer = SoundPlayer() 
    var body: some View {
        ZStack{
            VStack {
                WhatTimer2(timer: time)
                    .animation(.easeInOut, value: time)
                if(countup){
                    Button {
                        Task{
                            showAlert = true
                            AlertType = .end
                        }
                    } label: {
                        ZStack{
                            Rectangle()
                                .foregroundColor(ButtonColor)
                                .frame(width: 200, height: 70)
                                .cornerRadius(20)
                            Text("Stop")
                                .foregroundColor(darkBlue)
                        }
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
                countup = true
            }
            
            if motionManager.isAccelerometerAvailable {
                motionManager.accelerometerUpdateInterval = 0.5
                motionManager.startAccelerometerUpdates(to: .main) { data, error in
                    guard let data else { return }
                    inicore_x = data.acceleration.x
                    inicore_y = data.acceleration.y
                    inicore_z = data.acceleration.z
                }
            }
            
        }
        .onDisappear {
            timerActive = false // タイマーを停止
        }
        .onReceive(timer) { _ in
            Task{
                if(timerActive){
                    time -= 1
                    await corestart()
                    if(time == 0){
                        musicplayer.playMusic()
                        Moniter = false
                        timerActive = false
                        Task{
                            await Report(channelid: channelid, name: username, realtime: time, close: true,inittime: initimer)
                        }
                        
                    }
                }
                if(countup){
                    time += 1
                    await corestart()
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
//            print("\(scenePhase)")
            if (scenePhase == .background){
                isInBackground = true
            }
            if(scenePhase == .active){
                isInBackground = false
            }
            if (scenePhase == .inactive && Moniter && !isInBackground){
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
            case .end:
                Alert(
                    title: Text("終了しますか？"),
                    message: Text("この操作はやり直せません"),
                    primaryButton: .destructive(Text("終了")) {
                        Task{
                            Moniter = false
                            countup = false
                            await Report(channelid: channelid, name: username, realtime: time, close: true, inittime: initimer)
                            
                        }
                    },
                    secondaryButton: .cancel(Text("キャンセル"))
                )
            case nil:
                Alert(title: Text("エラー"))
            }
            
        }
        
    }
    
    
    private func Report(channelid: String, name: String, realtime: Int, close: Bool, inittime: Int) async {
        var Ktime = inittime - realtime
        if(Ktime < 0){
            Ktime = realtime
        }
        recode(date: date, realtime: Ktime, settingtime: inittime, close: close)
        let reporter = API(channelid: channelid, name: name, time: Ktime, close: close)
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
    
    
    private func corestart() async {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.5
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                guard let data else { return }
                core_x = data.acceleration.x
                core_y = data.acceleration.y
                core_z = data.acceleration.z
                
                core = !(abs(inicore_x - core_x) <= 0.1 || abs(inicore_y - core_y) <= 0.1 || abs(inicore_z - core_z) <= 0.1)
            }
        }
        
        if core && Moniter{
            countup = false
            Moniter = false
            await Report(channelid: channelid, name: username, realtime: time, close: false, inittime: initimer)
        }
    }
    
    private func recode(date: Date, realtime: Int, settingtime: Int, close: Bool) {
        // 現在のリストを取得
        var recodeTimeList = loadRecodeListFromDefaults()
        
        // 新しいデータを作成
        let newRecode = recodeModel(num: recodeTimeList.count, date: date, realtime: realtime, settingtime: settingtime, close: close)
        
        
        
        // リストに新しいデータを追加
        recodeTimeList.append(newRecode)
        // エンコードして保存
        if let encoded = try? JSONEncoder().encode(recodeTimeList) {
            UserDefaults.standard.set(encoded, forKey: "recodelist")
        }
    }

    private func loadRecodeListFromDefaults() -> [recodeModel] {
        if let savedData = UserDefaults.standard.data(forKey: "recodelist"),
           let decoded = try? JSONDecoder().decode([recodeModel].self, from: savedData) {
            return decoded
        }
        return []
    }
}
