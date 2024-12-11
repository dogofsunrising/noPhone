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
                VStack(spacing: 20) {
                    Text("設定の変更")
                        .font(.headline)
                    // チャンネルIDを入力するTextField
                    TextField("チャンネルIDを入力", text: $channelid)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
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
                .background(Color.white)
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
