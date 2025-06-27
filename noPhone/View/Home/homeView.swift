import SwiftUI

struct HomeView: View {
    @State var textInputView: Bool = false
    @State var title:String = UserDefaults.standard.string(forKey: "title") ?? ""
    @State var popCheck: Bool = false
    
    @Binding var stopTimer: Bool
    @State var Ad: Bool = false
    var body: some View {
        ZStack{
            Home2View(popCheck: $popCheck, textInputView: $textInputView,title: $title)
            if(textInputView){
                textView(textInputView: $textInputView,title: $title)
            }
            
            if(popCheck){
                POPstartView(stop: $stopTimer,popstart: $popCheck, title: $title)
            }
        }
    }
}

struct Home2View: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var setting = false
    @Binding var popCheck:Bool
    
    @Binding var textInputView: Bool
    
    @State private var isOn = true
    
    @State private var showAlert: Bool = false
    @State private var channelid: String = ""
    @State private var username: String = ""
    @State private var time: Int = 0
    @State private var timerList: [Int] = []
    @Binding var title: String
        
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
                
                VStack{
                Button {
                    textInputView = true
                } label: {
                    HStack {
                        Text("Title: ")
                        if(title == ""){
                            Text("Not Set")
                        } else {
                            Text(title)
                        }
                        Spacer()
                    }
                    .padding() // 必要なら余白
                    .background(Color.cyan) // 背景色を設定
                    .cornerRadius(20)

                }
                    
                }
                .padding(.vertical, 3)
                .padding(.horizontal, 20)
                
                
                TimerView(showAlert: $showAlert, delete: $delete, time: $time)
            }
        }
        .alert(isPresented: $showAlert) {
            switch delete {
            case .load:
                return Alert(
                    title: Text("削除しますか？"),
                    message: Text("この操作はやり直せません"),
                    primaryButton: .destructive(Text("削除")) {
                        delete = .yes
                    },
                    secondaryButton: .cancel(Text("キャンセル")) {
                        delete = .non
                    }
                )
            default:
                return Alert(
                    title: Text("エラー"),
                    message: Text("チャンネルIDまたはユーザー名が保存されていません"),
                    dismissButton: .default(Text("OK"))
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
