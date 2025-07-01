import SwiftUI

struct ChannelPageView: View {
    @Binding var isPage: Bool
    @Binding var channelIndex: Int
    let channel: Channel
    @Binding var isShowAlert:Bool
    @Binding var AlertType: SettingAlertType
    
    
    
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
                .onTapGesture {
                    isPage = false
                }
            VStack{
                Spacer()
                VStack{
                    Text("NAME: \(channel.name)")
                    Text("TYPE: \(channel.channelid.keys)")
                    Text("KEY : \(channel.channelid.values)")
                    Button("プラットフォームの削除") {
                        isShowAlert = true
                        AlertType = .channelDelete(index: channelIndex)
                    }
                }
                Spacer()
            }
        }
    }
}
