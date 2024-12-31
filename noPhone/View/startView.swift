import SwiftUI

struct StartView: View {
    @Binding var Screen: Screen
    @State private var setting = false
    @State private var popstart = false
    
    @State private var isOn = true
    
    @State private var showAlert: Bool = false
    @State private var channelid: String = ""
    @State private var username: String = ""
    @State private var time: Int = 0
    @State private var timerList: [Int] = []
        
    @State private var delete:DeleteType = .non
    var body: some View {
        ZStack{
            VStack {
                WhatTimer2(timer: time)
                HStack{
                    Button {
                        popstart = true
                    } label: {
                        ZStack{
                            Rectangle()
                                .foregroundColor(ButtonColor)
                                .frame(width: 250, height: 150)
                                .cornerRadius(20)
                            Text("Start")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(darkBlue)
                        }
                    }
                    VStack{
                        Button(action: {
                            setting.toggle()
                        }) {
                            HStack {
                                Image(systemName: "gear") // 歯車アイコン
                                    .resizable() // サイズを変更可能にする
                                    .frame(width: 50, height: 50) // 幅と高さを指定
                                    .foregroundColor(ButtonColor) // アイコンの色を白に設定
                            }
                            
                        }
                        
                        Button {
                            Screen = .recode
                        } label: {
                            ZStack{
                                Rectangle()
                                    .foregroundColor(ButtonColor)
                                    .frame(width: 50, height: 100)
                                    .cornerRadius(20)
                                Text("記録")
                                    .foregroundColor(darkBlue)
                            }
                        }
                    }
                }
                
                TimerView(showAlert: $showAlert, delete: $delete, time: $time)
                BannerContentView(navigationTitle: "Banner")
            }
            
            
            if(setting){
                SettingView(setting: $setting)
            }
            
            if(popstart){
                POPstartView(popstart: $popstart, Screen: $Screen)
            }
        }
        .alert(isPresented: $showAlert) {
            
            if(delete != .load){
                Alert(
                    title: Text("エラー"),
                    message: Text("チャンネルIDまたはユーザー名が保存されていません"),
                    dismissButton: .default(Text("OK"),action: {
                        
                    })
                )
            } else {
                Alert(
                    title: Text("削除しますか？"),
                    message: Text("この操作はやり直せません"),
                    primaryButton: .destructive(Text("削除")) {
                        delete = .yes
                    },
                    secondaryButton: .cancel(Text("キャンセル")){
                        delete = .non
                    }
                )
            }
        }
        .onAppear {
            channelid = UserDefaults.standard.string(forKey: "channelid") ?? ""
            username = UserDefaults.standard.string(forKey: "username") ?? ""
            time = UserDefaults.standard.integer(forKey: "selectedTimer")
            timerList = UserDefaults.standard.array(forKey: "timerList") as? [Int] ?? []
            if channelid.isEmpty || username.isEmpty {
                showAlert = true
                setting.toggle()
            } else {
                showAlert = false
            }
            
            if time == 0 {
                isOn = false
            }
            
            if(timerList.isEmpty){
                let numbers: [Int] = [1800, 3600, 7200, 10800]
                UserDefaults.standard.set(numbers, forKey: "timerList")
            }
        }
    }
}
