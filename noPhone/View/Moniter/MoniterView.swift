import SwiftUI

struct MoniterView: View {
    @State var isRecode: Bool = false
    var body: some View {
        VStack {
            if(!isRecode){
                VStack {
                    RecoMainView(isRecode: $isRecode)
                    ScreenTimeMainView()
                }
            }else{
                RecodeView(isRecode: $isRecode)
            }
        }
    }
}
