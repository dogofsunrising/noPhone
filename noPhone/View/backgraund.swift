import SwiftUI

struct GradientBackgroundView: View {
    var body: some View {
        ZStack {
            // グラデーション背景
            LinearGradient(
                gradient: Gradient(colors: [
                    darkBlue, // 下: 濃い青
                    mediumBlue, // 中間: 少し明るい青
                    lightBlue  // 上: 明るいシアン
                ]),
                startPoint: .bottom,  // 下から始まる
                endPoint: .top        // 上で終わる
            )
            .ignoresSafeArea() // 全画面に適用
            
            // コンテンツ (例: おしゃれなデザイン要素)
            VStack {
                Text("Welcome to App!!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.2))
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                    )
                    .padding(.top, 100)
                
                Spacer()
                
                Text("Enjoy the experience!")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 50)
            }
        }
    }
}

