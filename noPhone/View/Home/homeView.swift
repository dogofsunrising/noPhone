import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var setting = false
    @State private var popCheck = false
    
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
                MainTimer(timer: time)
                HStack{
                    Button {
                        popCheck = true
                    } label: {
                        ZStack{
                            Rectangle()
                                .foregroundColor(ButtonColor(how: .button, scheme: colorScheme))
                                .frame(width: 250, height: 150)
                                .cornerRadius(20)
                            Text("Start")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(ButtonColor(how: .text, scheme: colorScheme))
                        }
                    }
                }
                
                TimerView(showAlert: $showAlert, delete: $delete, time: $time)
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
            if(timerList.isEmpty){
                let numbers: [Int] = [1800, 3600, 7200, 10800]
                UserDefaults.standard.set(numbers, forKey: "timerList")
                timerList = UserDefaults.standard.array(forKey: "timerList") as? [Int] ?? []
            }
            if channelid.isEmpty || username.isEmpty {
                showAlert = true
                setting.toggle()
            } else {
                showAlert = false
            }
            
            if time == 0 {
                isOn = false
            }
            
            
        }
    }
}
