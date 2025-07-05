import SwiftUI
import FamilyControls

struct SettingView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var channels: [Channel] = []
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State private var selectedtimer: TimerType = TimerType(rawValue: UserDefaults.standard.string(forKey: "timertype") ?? "") ?? .default
    @State private var errorMessage: String? = nil // エラーメッセージ
    @FocusState private var isInputActive: Bool
    
    @State private var isChannels: Bool = false
    @State private var isShowAlert: Bool = false
    @State private var AlertType: SettingAlertType = .non
    
    @State private var isChannelPage: Bool = false
    @State private var selectedChannelIndex: Int = 0
    
    @State private var isChannelAdd: Bool = false
    
    @State var blur: Bool = true
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
                .onTapGesture {
                    isInputActive = false
                }

            VStack {
                Spacer()
                VStack(spacing: 16) {
                    Text("設定の変更")
                        .font(.title2.bold())
                        .padding(.top)

                    // ユーザー名入力欄
                    TextField("ユーザー名を入力", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .focused($isInputActive)

                    // ScreenTime ボタン
                    Button(action: {
                        AlertType = .auth
                        isShowAlert = true
                    }) {
                        Text(blur ? "ScreenTimeへのアクセスを許可" : "ScreenTimeへのアクセスを制限")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }

                    // タイマーカスタム設定
                    HStack {
                        Text("タイマーカスタム")
                            .font(.subheadline)
                        Spacer()
                        Picker("タイマー", selection: $selectedtimer) {
                            Text("default").tag(TimerType.default)
                            Text("circle").tag(TimerType.circle)
                        }
                        .pickerStyle(.menu)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Divider().padding(.horizontal)

                    // チャンネル設定
                    VStack(spacing: 8) {
                        ChannelsView(channels: $channels,
                                     PageIndex: $selectedChannelIndex,
                                     isShowPage: $isChannelPage,
                                     ChannelAdd: $isChannelAdd)

                        if channels.isEmpty {
                            Text("チャンネルが未設定です")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        // チャンネルIDとはリンク
//                        HStack {
//                            Spacer()
//                            Link("チャンネルIDとは？", destination: URL(string: "https://support.discord.com/hc/ja/articles/206346498")!)
//                                .font(.caption)
//                                .foregroundColor(.blue)
//                                .padding(.trailing, 16)
//                        }
                    }
                    .padding(.horizontal)

                    // エラー表示
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 4)
                    }

                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(ButtonColor(how: .undefault, scheme: colorScheme))
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                )
                .padding(.horizontal)
                Spacer()
            }

            // ページ遷移部分
            if isChannelPage {
                ChannelPageView(isPage: $isChannelPage,
                                channelIndex: $selectedChannelIndex,
                                channel: channels[selectedChannelIndex],
                                isShowAlert: $isShowAlert,
                                AlertType: $AlertType)
            } else if isChannelAdd {
                ChannelAddPageView(isPage: $isChannelAdd,
                                   channels: $channels)
            }
        }
        .alert(isPresented: $isShowAlert) {
            switch AlertType {
            case .channelDelete(let index):
                    return Alert(
                        title: Text("削除しますか？"),
                        message: Text("この操作はやり直せません"),
                        primaryButton: .destructive(Text("削除")) {
                            isChannelPage = false
                            if channels.indices.contains(index) {
                                channels.remove(at: index)
                            }
                        },
                        secondaryButton: .cancel(Text("キャンセル")) {
                            isShowAlert = false
                        }
                    )
                case .auth:
                if(blur){
                    return Alert(
                        title: Text("スクリーンタイム認証"),
                        message: Text("スクリーンタイムの取得を許可しますか？"),
                        primaryButton: .destructive(Text("許可")) {
                            Task{
                                await authorize()
                                isShowAlert = false
                                blur = false
                            }
                        },
                        secondaryButton: .cancel(Text("キャンセル")) {
                            isShowAlert = false
                        }
                    )
                } else {
                    return Alert(
                        title: Text("スクリーンタイム認証"),
                        message: Text("スクリーンタイムの取得を制限しますか？"),
                        primaryButton: .destructive(Text("制限")) {
                            Task{
                                await deauthorize()
                                isShowAlert = false
                                blur = true
                            }
                        },
                        secondaryButton: .cancel(Text("キャンセル")) {
                            isShowAlert = false
                        }
                    )
                }
                
                case .non:
                    return Alert(
                        title: Text("無効の入力"),
                        message: Text("エラーが起きてます"),
                        dismissButton: .default(Text("OK"))
                    )
                }
        }
        .onAppear {
            if let data = UserDefaults.standard.data(forKey: "channels"),
               let decoded = try? JSONDecoder().decode([Channel].self, from: data) {
                channels = decoded
            }
            username = UserDefaults.standard.string(forKey: "username") ?? ""
            
            _ = AuthorizationCenter.shared.$authorizationStatus
                .sink() {_ in
                switch AuthorizationCenter.shared.authorizationStatus {
                case .notDetermined:
                    blur = true
                case .denied:
                    blur = true
                case .approved:
                    blur = false
                @unknown default:
                    print("authorizationStatus error")
                    blur = true
                }
            }
        }
        .onDisappear {
            if let encoded = try? JSONEncoder().encode(channels) {
                UserDefaults.standard.set(encoded, forKey: "channels")
            }
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(selectedtimer.rawValue, forKey: "timertype")
        }
    }
    func authorize() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        } catch {
                
        }
    }
}

struct Channel: Decodable, Encodable, Hashable {
    var name: String
    var channelid: [String: String]
    
    init(name: String, channelid: [String: String]) {
        self.name = name
        self.channelid = channelid
    }
}
