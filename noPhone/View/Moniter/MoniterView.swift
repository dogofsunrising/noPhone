import SwiftUI
import FamilyControls

struct MoniterView: View {
    @State var isRecode: Bool = false
    @State var isOn: Bool = false
    
    @State var selection = FamilyActivitySelection(includeEntireCategory: false)
    @State var shield: Bool = false
    var body: some View {
        VStack {
            if(!isRecode){
                VStack {
                    RecoMainView(isRecode: $isRecode)
                    Picker("時間区切り", selection: $shield) {
                        Text("カテゴリ別スクリーンタイム").tag(false)
                        Text("アプリの制限").tag(true)
                    }
                    ZStack{
                        ScreenTimeMainView()
                        
                        if(shield){
                            AppShieldView(selection: $selection)
                        }
                    }
                }
            }else{
                RecodeView(isRecode: $isRecode)
            }
        }
    }
}
