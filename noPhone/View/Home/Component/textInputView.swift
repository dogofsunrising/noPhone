import SwiftUI

struct textView: View {
    @Binding var textInputView: Bool
    @Binding var title:String
    @State private var titles:[String] = []
    @State private var todos:[TodoItem] = []
    var body: some View {
        
        ZStack{
            // 背景を透明な黒に設定Add commentMore actions
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all) // 全画面を覆う
                .onTapGesture {
                    textInputView = false
                }
            VStack {
                Spacer()
                // 白い四角形
                VStack(spacing: 10) {
                    Text("タイトルの変更")
                        .font(.headline)
                    
                    // ユーザー名を入力するTextField
                    TextField("入力", text: $title)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                    
                    VStack{
                        HStack{
                            VStack{
                                Text("履歴")
                                    .font(.subheadline)
                                
                                ForEach(titles, id: \.self) { index in
                                    Button(action: {
                                        title = index // ボタンを押すと `title` を更新
                                    }, label: {
                                        Text(index)
                                            .foregroundColor(.blue)
                                    })
                                }
                            }
                            
                            VStack {
                                Text("Todo")
                                    .font(.subheadline)
                                
                                ForEach(todos.prefix(10), id: \.self) { item in
                                    Button(action: {
                                        title = item.text // ボタンを押すと `title` を更新
                                    }) {
                                        Text(item.text)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                        
                    }
                    // 保存ボタン
                    Button(action: {
                        textInputView = false
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
            titles = loadTitles()
            loadTodo()
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
    
    private func loadTodo() {
        if let data = UserDefaults.standard.data(forKey: "todoList"),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
            todos = decoded
        }
    }
}
