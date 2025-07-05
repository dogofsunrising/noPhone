import SwiftUI
import FamilyControls

struct SettingView: View {
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
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
                .onTapGesture {
                    isInputActive = false
                }
            
            VStack {
                Spacer()
                // 白い四角形
                VStack(spacing: 10) {
                    Text("設定の変更")
                        .font(.headline)
                    
                    // ユーザー名を入力するTextField
                    TextField("ユーザー名を入力", text: $username)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        .focused($isInputActive)
                    
                    Button (action: {
                        AlertType = .auth
                        isShowAlert = true
                    } ) {
                        ZStack{
                            Rectangle()
                                .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.1))
                                .frame(width: .infinity, height: 50)
                                .cornerRadius(20)
                                .padding(.horizontal)
                            if(blur){
                                Text("ScreenTimeへのアクセスを許可")
                            } else {
                                Text("ScreenTimeへのアクセスを制限")
                            }
                        }
                    }
                    
                    HStack{
                        Text("タイマーカスタム")
                        Picker("タイマー画面の設定", selection: $selectedtimer) {
                            Text("default").tag(TimerType.default)
                            Text("circle").tag(TimerType.circle)
                        }
                        .pickerStyle(.menu)
                    }
                    .padding()
                    .background(Color(red: 0, green: 0, blue: 0, opacity: 0.1))
                    .cornerRadius(5)
                    
                    
                    
                    VStack{
                        
                        ChannelsView(channels: $channels, PageIndex: $selectedChannelIndex, isShowPage: $isChannelPage, ChannelAdd: $isChannelAdd)
                        HStack{
                            Spacer()
//                            Link("チャンネルIDとは？", destination: URL(string: "https://support.discord.com/hc/ja/articles/206346498-%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC-%E3%83%A1%E3%83%83%E3%82%BB%E3%83%BC%E3%82%B8ID%E3%81%AF%E3%81%A9%E3%81%93%E3%81%A7%E8%A6%8B%E3%81%A4%E3%81%91%E3%82%89%E3%82%8C%E3%82%8B")!)
//                                .font(.caption)
//                                .foregroundColor(.blue)
//                                .padding(.horizontal, 20)
                        }
                    }
                    if(channels.isEmpty){
                        Spacer()
                    }
                    
                    // エラーメッセージを表示
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                }
                Spacer()
            }
            
            if(isChannelPage){
                ChannelPageView(isPage: $isChannelPage, channelIndex: $selectedChannelIndex,channel: channels[selectedChannelIndex] ,isShowAlert: $isShowAlert, AlertType: $AlertType)
            } else if(isChannelAdd){
                ChannelAddPageView(isPage: $isChannelAdd, channels: $channels)
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
