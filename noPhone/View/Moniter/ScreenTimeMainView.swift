import SwiftUI
import FamilyControls


struct ScreenTimeMainView: View {
    @State var blur: Bool = true

        var body: some View {
        ZStack {
            // ぼかしたい対象全体
            VStack {
                Button {
                    Task {
                        await deauthorize()
                    }
                } label: {
                    Text("Check")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            // ぼかしと操作無効化
            .blur(radius: blur ? 5 : 0)
            .disabled(blur)

            // オーバーレイとしてタップ防止＋ぼかし中の表示（オプション）
            if blur {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                Button {
                    Task {
                        await authorize()
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 200, height: 50)
                            .cornerRadius(10)
                            .opacity(0.5)
                            .shadow(radius: 10)
                        Text("Screen Timeの監視を許可")
                    }
                    
                }

            }
        }
        .onAppear {
            _ = AuthorizationCenter.shared.$authorizationStatus
                .sink() {_ in
                switch AuthorizationCenter.shared.authorizationStatus {
                case .notDetermined:
                    blur = true
                case .denied:
                    blur = true
                case .approved:
                    blur = false
                @unknown default:
                    print("authorizationStatus error")
                    blur = true
                }
            }
        }
    }
}

func authorize() async {
    do {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    } catch {
            
    }
}

func deauthorize() async {
    AuthorizationCenter.shared.revokeAuthorization { result in
        switch result {
        case .success():
            print("削除成功")
        case .failure(let error):
            print(error)
        }
    }
}
