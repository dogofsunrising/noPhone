import SwiftUI

struct ChannelsView: View {
    @Binding var channels: [Channel]
    @Binding var PageIndex: Int
    @Binding var isShowPage: Bool
    @Binding var ChannelAdd: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Channels")
                    .font(.headline)
                Spacer()
                Button("プラットフォームの追加") {
                    ChannelAdd = true
                }
            }
            .padding(.horizontal)
            if(channels.isEmpty){
                HStack{
                    Spacer()
                    Text("プラットフォームが設定されていません")
                    Spacer()
                }
            } else {
                List{
                    ForEach(Array(channels.enumerated()), id: \.element) { index, channel in
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(channel.channelid.sorted(by: { $0.key < $1.key }), id: \.key) { platform, id in
                                Button(action: {
                                    PageIndex = index
                                    isShowPage = true
                                }) {
                                    HStack {
                                        Text("\(platform.uppercased()): \(channel.name)")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
}

