import SwiftUI

struct LoadingAlert: View {
    @State private var dotCount = 0
    
    private let maxDotCount = 3
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("読み込み中" + String(repeating: ".", count: dotCount) + String(repeating: " ", count: 3-dotCount))
                .foregroundColor(.black)
                .font(.headline)
        }
        .padding(30)
        .background(
            Color(UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
            })
        )
        .cornerRadius(10)
        .shadow(radius: 10)
        .onReceive(timer) { _ in
            if dotCount < maxDotCount {
                dotCount += 1
            } else {
                dotCount = 0
            }
        }
    }
}
