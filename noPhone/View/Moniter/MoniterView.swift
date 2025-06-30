import SwiftUI

struct MoniterView: View {
    @State var isRecode: Bool = false
    var body: some View {
        VStack {
            if(!isRecode){
                RecoMainView(isRecode: $isRecode)
            }else{
                RecodeView(isRecode: $isRecode)
            }

        }
    }
}
