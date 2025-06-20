import SwiftUI

struct GradientBackgroundView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var light1 = Color(hex: "1E90FF")
    private var light2 = Color(hex: "63B8FF")
    private var light3 = Color(hex: "B0E2FF")

    private var dark1 = Color(hex: "191970")
    private var dark2 = Color(hex: "0000cd")
    private var dark3 = Color(hex: "1E90FF")
    
    var body: some View {
        if(colorScheme == .light){
            ZStack {
                // グラデーション背景
                LinearGradient(
                    gradient: Gradient(colors: [
                        light1, // 下: 濃い青
                        light2, // 中間: 少し明るい青
                        light3  // 上: 明るいシアン
                    ]),
                    startPoint: .bottom,  // 下から始まる
                    endPoint: .top        // 上で終わる
                )
                .ignoresSafeArea() // 全画面に適用
                
                // コンテンツ (例: おしゃれなデザイン要素)
                VStack {
                }
            }
        } else {
            ZStack {
                // グラデーション背景
                LinearGradient(
                    gradient: Gradient(colors: [
                        dark1, // 下: 濃い青
                        dark2, // 中間: 少し明るい青
                        dark3  // 上: 明るいシアン
                    ]),
                    startPoint: .bottom,  // 下から始まる
                    endPoint: .top        // 上で終わる
                )
                .ignoresSafeArea() // 全画面に適用
                
                // コンテンツ (例: おしゃれなデザイン要素)
                VStack {
                }
            }
        }
    }
}


