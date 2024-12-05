import SwiftUI

struct StartView: View {
    @Binding var isWaiting: Bool

    init(isWaiting: Binding<Bool>) {
        self._isWaiting = isWaiting
    }

    var body: some View {
        VStack {
            Button {
                isWaiting.toggle()
            } label: {
                Text("Start")
            }
        }
    }
}
