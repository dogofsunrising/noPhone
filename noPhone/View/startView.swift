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
                ZStack{
                   
                    Rectangle()
                        .foregroundColor(.blue)
                        .frame(width: 200, height: 200)
                    Text("Start")
                        .foregroundColor(.white)
                }
            }
        }
    }
}
