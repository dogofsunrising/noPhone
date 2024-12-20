import SwiftUI

struct SettingView: View {
    @Binding var setting: Bool // ポップアップを表示するかどうかの状態
    @State private var channelid: String = UserDefaults.standard.string(forKey: "channelid") ?? ""
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State private var errorMessage: String? = nil // エラーメッセージ
    
    var body: some View {
        ZStack {
            // 背景を透明な黒に設定
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all) // 全画面を覆う
                .onTapGesture {
                    if channelid.isEmpty || username.isEmpty {
                        errorMessage = "すべてのフィールドを入力してください"
                    } else {
                        UserDefaults.standard.set(channelid, forKey: "channelid")
                        UserDefaults.standard.set(username, forKey: "username")
                        errorMessage = nil
                        setting = false // ポップアップを閉じる
                    }
                }
            VStack {
                Spacer()
                // 白い四角形
                VStack(spacing: 10) {
                    Text("設定の変更")
                        .font(.headline)
                    VStack{
                        
                        // チャンネルIDを入力するTextField
                        TextField("チャンネルIDを入力", text: $channelid)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                        HStack{
                            Spacer()
                            Link("チャンネルIDとは？", destination: URL(string: "https://support.discord.com/hc/ja/articles/206346498-%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC-%E3%83%A1%E3%83%83%E3%82%BB%E3%83%BC%E3%82%B8ID%E3%81%AF%E3%81%A9%E3%81%93%E3%81%A7%E8%A6%8B%E3%81%A4%E3%81%91%E3%82%89%E3%82%8C%E3%82%8B")!)
                                .font(.caption)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 20)
                        }
                    }
                    // ユーザー名を入力するTextField
                    TextField("ユーザー名を入力", text: $username)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                    // エラーメッセージを表示
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    // 保存ボタン
                    Button(action: {
                        if channelid.isEmpty || username.isEmpty {
                            errorMessage = "すべてのフィールドを入力してください"
                        } else {
                            UserDefaults.standard.set(channelid, forKey: "channelid")
                            UserDefaults.standard.set(username, forKey: "username")
                            errorMessage = nil
                            setting = false // ポップアップを閉じる
                        }
                    }) {
                        Text("保存")
                            .foregroundColor(.blue)
                            .padding(.top, 10)
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
    }
}
