import SwiftUI

struct SettingView: View {
    @State private var channelid: String = UserDefaults.standard.string(forKey: "channelid") ?? ""
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State private var selectedtimer: TimerType = TimerType(rawValue: UserDefaults.standard.string(forKey: "timertype") ?? "") ?? .default
    @State private var errorMessage: String? = nil // エラーメッセージ
    @FocusState private var isInputActive: Bool
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
                .onTapGesture {
                    isInputActive = false
                }
            VStack {
                Spacer()
                // 白い四角形
                VStack(spacing: 10) {
                    Text("設定の変更")
                        .font(.headline)
                    
                    // ユーザー名を入力するTextField
                    TextField("ユーザー名を入力", text: $username)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        .focused($isInputActive)
                    
                    VStack{
                        
                        // チャンネルIDを入力するTextField
                        TextField("チャンネルIDを入力", text: $channelid)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                            .focused($isInputActive)
                        HStack{
                            Spacer()
                            Link("チャンネルIDとは？", destination: URL(string: "https://support.discord.com/hc/ja/articles/206346498-%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC-%E3%83%A1%E3%83%83%E3%82%BB%E3%83%BC%E3%82%B8ID%E3%81%AF%E3%81%A9%E3%81%93%E3%81%A7%E8%A6%8B%E3%81%A4%E3%81%91%E3%82%89%E3%82%8C%E3%82%8B")!)
                                .font(.caption)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 20)
                        }
                    }
                    HStack{
                        Text("タイマーカスタム")
                        Picker("タイマー画面の設定", selection: $selectedtimer) {
                            Text("default").tag(TimerType.default)
                            Text("circle").tag(TimerType.circle)
                        }
                        .pickerStyle(.menu)
                    }
                    .padding()
                    .background(Color(red: 0, green: 0, blue: 0, opacity: 0.1))
                    .cornerRadius(5)
                    
                    // エラーメッセージを表示
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                }
                .padding()
                .background(
                    Color(UIColor { traitCollection in
                        return traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
                    })
                )
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(.horizontal, 40) // 四角形の幅を調整
                Spacer()
            }
        }
        .onAppear {
            // ビューが表示されたとき、ローカルデータをロード
            channelid = UserDefaults.standard.string(forKey: "channelid") ?? ""
            username = UserDefaults.standard.string(forKey: "username") ?? ""
        }
        .onDisappear{
            UserDefaults.standard.set(channelid, forKey: "channelid")
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(selectedtimer.rawValue, forKey: "timertype")
        }
    }
}
