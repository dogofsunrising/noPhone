import SwiftUI

struct LoadingAlert: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("読み込み中...")
                .font(.headline)
        }
        .padding(30)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
