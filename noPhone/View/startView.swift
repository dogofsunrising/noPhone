import SwiftUI

struct StartView: View {
    @Binding var Screen: Screen
    @State private var setting = false
    
    @State private var isOn = true
    
    @State private var showAlert: Bool = false
    @State private var channelid: String = ""
    @State private var username: String = ""
    @State private var time: Int = 0
    @State private var timerList: [Int] = []
        
    var body: some View {
        ZStack{
            VStack {
                WhatTimer(timer: time)
                Button {
                    Screen = .stop // 画面遷移のロジック
                } label: {
                    ZStack{
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(width: 200, height: 200)
                        Text("Start")
                            .foregroundColor(.white)
                    }
                }
                HStack{
                    Spacer()
                    Button(action: {
                        setting.toggle()
                    }) {
                        HStack {
                            Image(systemName: "gear") // 歯車アイコン
                                .resizable() // サイズを変更可能にする
                                .frame(width: 70, height: 70) // 幅と高さを指定
                                .foregroundColor(.gray) // アイコンの色を白に設定
                        }
                        
                    }
                    Button(action: {
                        Screen = .timer
                        isOn.toggle()
                    }) {
                        HStack {
                            Image(systemName: "timer") // アイコン
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(isOn ? .blue : .gray) // 状態によって色を変更
                        }
                        
                    }
                    Spacer()
                }
            }
            
            if(setting){
                SettingView(setting: $setting)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("エラー"),
                message: Text("チャンネルIDまたはユーザー名が保存されていません"),
                dismissButton: .default(Text("OK"),action: {
                    
                })
            )
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
