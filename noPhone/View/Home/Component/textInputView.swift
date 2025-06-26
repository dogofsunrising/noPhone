import SwiftUI

struct textView: View {
    @Binding var textInputView: Bool
    @Binding var title:String
    var body: some View {
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
                        
                    
                    }
                    // 保存ボタン
                    Button(action: {
                        textInputView = false
                    }) {
                        Text("終了")
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
}
