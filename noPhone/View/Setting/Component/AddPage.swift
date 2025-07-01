import SwiftUI

struct ChannelAddPageView: View {
    @Binding var isPage: Bool
    @Binding var channels: [Channel]
    
    @State var newChannelName: String = ""
    @State var newChannelPlatform: String = ""
    @State var newChannelID: String = ""
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
                .onTapGesture {
                    isPage = false
                }
            
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    Text("新しいチャンネルの追加")
                        .font(.headline)
                    
                    TextField("Channel Name", text: $newChannelName)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    HStack(spacing: 10) {
                        Button {
                            newChannelPlatform = "line"
                        } label: {
                            Text("LINE")
                                .padding()
                                .background(newChannelPlatform == "line" ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }

                        Button {
                            newChannelPlatform = "discord"
                        } label: {
                            Text("DISCORD")
                                .padding()
                                .background(newChannelPlatform == "discord" ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                        Button {
                            newChannelPlatform = "slack"
                        } label: {
                            Text("SLACK")
                                .padding()
                                .background(newChannelPlatform == "slack" ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }

                    TextField("Channel ID", text: $newChannelID)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    Button {
                        guard !newChannelName.isEmpty,
                              !newChannelPlatform.isEmpty,
                              !newChannelID.isEmpty else { return }
                        
                        let newChannel = Channel(
                            name: newChannelName,
                            channelid: [newChannelPlatform: newChannelID]
                        )
                        channels.append(newChannel)
                        isPage = false
                    } label: {
                        Text("保存")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
    }
}
