import SwiftUI

struct POPChannelsView: View {
    @Binding var channels: [Channel]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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
                                HStack {
                                    Text("\(platform.uppercased()): \(channel.name)")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
}

