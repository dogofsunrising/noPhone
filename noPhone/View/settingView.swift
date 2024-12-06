import SwiftUI

struct SettingView: View {
    @Binding var setting: Bool // ポップアップを表示するかどうかの状態
    @State private var username: String = "" // ユーザー名

    var body: some View {
        ZStack {
            // 背景を透明な黒に設定
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all) // 全画面を覆う
                .onTapGesture {
                    setting = false
                }
            VStack {
                Spacer()

                // 白い四角形
                VStack(spacing: 20) {
                    Text("ユーザー名を変更")
                        .font(.headline)

                    // ユーザー名を入力するTextField
                    TextField("ユーザー名を入力", text: $username)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)

                    // 保存ボタン
                    Button(action: {
                        print("新しいユーザー名: \(username)")
                        setting = false // ポップアップを閉じる
                    }) {
                        Text("保存")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                    }

                    // キャンセルボタン
                    Button(action: {
                        setting = false // ポップアップを閉じる
                    }) {
                        Text("戻る")
                            .foregroundColor(.red)
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
    }
}

