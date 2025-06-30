import SwiftUI

struct POPstartView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var stop: Bool
    @Binding var popstart: Bool // ポップアップを表示するかどうかの状態
    @Binding var title:String
    @State var isButton:Bool = true
    @State var time:Int = 0
    @State var username:String = ""
    @State private var titles:[String] = []
    @State private var selectedtimer: TimerType = TimerType(rawValue: UserDefaults.standard.string(forKey: "timertype") ?? "") ?? .default
    @State private var errorMessage: String? = nil // エラーメッセージ
    @State private var isSaving = false
    
    var body: some View {
        ZStack {
            // 背景を透明な黒に設定
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all) // 全画面を覆う
                .onTapGesture {
                        popstart = false // ポップアップを閉じる
                    
                }
            VStack {
                Spacer()
                // 白い四角形
                VStack(spacing: 10) {
                    Text("確認")
                        .font(.headline)
                    MainTimer(timer: time)
                    HStack{
                        Text("ユーザーネーム")
                        
                        // ユーザー名を入力するTextField
                        Text(username)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                    }
                    
                    HStack{
                        Text("タイトル")
                        
                        // ユーザー名を入力するTextField
                        Text(title)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                    }
                    
                    HStack{
                        Text("タイマーの種類")
                        
                        // ユーザー名を入力するTextField
                        Text(selectedtimer.rawValue)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                    }
                    
                    // エラーメッセージを表示
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    HStack{
                        // 保存ボタン
                        Button(action: {
                            popstart = false
                        }) {
                            Text("キャンセル")
                                .foregroundColor(ButtonColor(how: .text, scheme: colorScheme))
                                .padding(.top, 10)
                        }
                        Spacer()
                        // 保存ボタン
                        Button(action: {
                            if title.isEmpty || username == "" {
                                errorMessage = "入力が不足しています"
                            } else if !isSaving {
                                isSaving = true
                                stop = true
                                Task {
                                    await saveTitles()
                                    isSaving = false
                                }
                            }
                        }) {
                            Text("確認して始める")
                                .foregroundColor(ButtonColor(how: .text, scheme: colorScheme))
                                .padding(.top, 10)
                        }
                        .disabled(!isButton)
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
            titles = loadTitles()
            username = UserDefaults.standard.string(forKey: "username") ?? ""
            time = UserDefaults.standard.integer(forKey: "selectedTimer")
            if title.isEmpty || username == "" {
                errorMessage = "入力が不足しています"
                isButton = false
            } else {
                isButton = true
            }
        }
    }
    
    private func saveTitles() async {
        // 現在のタイトルを保存（個別保存用）
        UserDefaults.standard.set(title, forKey: "title")

        errorMessage = nil
        popstart = false // ポップアップを閉じる
        // すでに同じタイトルがある場合は削除
        if let index = self.titles.firstIndex(of: title) {
            self.titles.remove(at: index)
        }
        
        // 新しいタイトルを先頭に追加
        self.titles.insert(title, at: 0)
        
        // 履歴を最大5つに制限
        if self.titles.count > 5 {
            self.titles.removeLast()
        }
        
        // 保存処理
        do {
            let data = try JSONEncoder().encode(titles)
            UserDefaults.standard.set(data, forKey: "titlelist")
//            Screen = .stop
            let reporter = API()
            await reporter.startAPI()
            
        } catch {
            print("Failed to encode titles: \(error)")
        }
    }


    
    private func loadTitles() -> [String] {
        if let savedData = UserDefaults.standard.data(forKey: "titlelist") {
            do {
                let titles = try JSONDecoder().decode([String].self, from: savedData)
                return titles
            } catch {
                print("Failed to decode titles: \(error)")
            }
        }
        return [] // データが存在しない場合やデコードに失敗した場合は空のリストを返す
    }

}
