import SwiftUI

struct StartView: View {
    @Binding var Screen: Screen
    @State private var isSwitchOn = false
    @State private var setting = false
    var body: some View {
        ZStack{
            VStack {
                Button {
                    Screen = .stop
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
                    }) {
                        HStack {
                            Image(systemName: "timer") // 歯車アイコン
                                .resizable() // サイズを変更可能にする
                                .frame(width: 70, height: 70) // 幅と高さを指定
                                .foregroundColor(.gray) // アイコンの色を白に設定
                        }
                        
                    }
                    Spacer()
                }
            }
            
            if(setting){
                SettingView(setting: $setting)
            }
        }
    }
    
    private func timer(){
        
    }
}
