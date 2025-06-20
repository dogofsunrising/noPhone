import SwiftUI

struct SubTimer: View {
    @Environment(\.colorScheme) var colorScheme
    var timer: Int
    var hours: Int
    var minutes: Int
    var seconds: Int
    var screenHeight: CGFloat // 画面高さを受け取る

    init(timer: Int, screenHeight: CGFloat) {
        self.timer = timer
        self.screenHeight = screenHeight
        self.hours = timer / 3600
        self.minutes = (timer % 3600) / 60
        self.seconds = timer % 60
    }

    var body: some View {
        GeometryReader { proxy in
            let itemMidY = proxy.frame(in: .global).midY // アイテムの中央Y座標
            let growThreshold = screenHeight*0.77 // 80%以下で縮小開始

            // スケール計算: 下では小さく (70%)、上に行くほど大きく (100%)
            let scale = itemMidY > growThreshold ? max(0.7, 1 - (itemMidY - growThreshold) / (screenHeight * 0.3)) : 1

            // 透明度計算: 下では薄く、上に行くと濃く
            let opacity = itemMidY > growThreshold ? max(0.3, 1 - (itemMidY - growThreshold) / (screenHeight * 0.3)) : 1

            VStack {
                Spacer()
                Text(String(format: "%02dh%02dm%02ds", hours, minutes, seconds))
                    .foregroundColor(ButtonColor(how: .default, scheme: colorScheme))
                    .font(.title2)
                    .fontWeight(.bold)
                    .scaleEffect(scale) // 🎬 スケール変化を適用
                    .opacity(opacity) // 🎨 フェードアウト適用
                    .animation(.easeOut(duration: 0.3), value: scale) // アニメーション
                    .animation(.easeOut(duration: 0.3), value: opacity)
                Spacer()

            }
        }
        .frame(height: 50) // 各行の高さ
    }
}

