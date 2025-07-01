import SwiftUI
import FamilyControls

struct ScreenTimeMainView: View {
    // これがAuthCenterとの共有を可能にします(シングルトンデザイン）
    var body: some View {
        ZStack {
            Button {
                    Task{
                        await authorize()
                    }
//                    print(selection)
//                    let applications = selection.applicationTokens
                
            } label: {
                Text("Check")
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
