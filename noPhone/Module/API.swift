import Foundation
import Alamofire

public final class API {
    private var channels_pre: [Channel] = []
    private var channels: [[String: String]] = [[:]]
    private var name = UserDefaults.standard.string(forKey: "username") ?? ""
    private var title = UserDefaults.standard.string(forKey: "title") ?? ""

//    public func test_closeAPI(time:Int,close:Bool) async -> String?{ return "test11111"}
    public func closeAPI(time:Int,close:Bool) async -> String? {
        channels = getChannels()
        // APIのURLを指定
        let urlString = "https://6fqsnu3hec.execute-api.ap-northeast-1.amazonaws.com/kouno/close"

        // 送信するJSONデータを作成
        let jsonData: [String: Any] = [
            "channelid": channels,
            "name": name,
            "close": close,
            "realtimer_seconds": time,
            "title": title
        ]
//        print(jsonData)

        return await withCheckedContinuation { continuation in
            // Alamofireを使用してPOSTリクエストを送信
            AF.request(urlString, method: .post, parameters: jsonData, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            // レスポンスデータをJSONとしてデコード
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let message = json["message"] as? String {
                                print("API Message: \(message)")
                                continuation.resume(returning: message) // 成功した場合に値を返す
                            } else {
                                print("Message key not found in response.")
                                continuation.resume(returning: nil) // JSONに "message" がない場合
                            }
                        } catch {
                            print("JSON decoding error: \(error.localizedDescription)")
                            continuation.resume(returning: nil) // デコードエラーの場合
                        }
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        continuation.resume(returning: nil) // リクエスト失敗の場合
                    }
                }
        }
    }

    
//    public func test_startAPI() {}
    public func startAPI() async {
        channels = getChannels()
        let urlString = "https://6fqsnu3hec.execute-api.ap-northeast-1.amazonaws.com/kouno/start"
        let jsonData: [String: Any] = [
            "channelid":  channels,
            "name": name,
            "title": title
        ]
        
        print(jsonData)

        await withCheckedContinuation { continuation in
            AF.request(urlString,
                       method: .post,
                       parameters: jsonData,
                       encoding: JSONEncoding.default,
                       headers: ["Content-Type": "application/json"])
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let statusCode = json["statusCode"] as? Int {
                            print("start API statusJSON: \(json)")
                            print("start API statusCode: \(statusCode)")
                        } else {
                            print("statusCode key not found in response.")
                        }
                        continuation.resume() // ✅ ここで完了通知（Void）
                    } catch {
                        print("JSON decoding error: \(error.localizedDescription)")
                        continuation.resume() // ✅ 失敗してもとにかく resume を呼ぶ
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    continuation.resume() // ✅ エラーでも resume を呼ぶ（throwing にしてもOK）
                }
            }
        }
    }
    
    func getChannels() -> [[String: String]] {
        // 前回のデータをクリア
        channels = []

        // UserDefaultsからデコード
        if let data = UserDefaults.standard.data(forKey: "channels"),
           let decoded = try? JSONDecoder().decode([Channel].self, from: data) {
            channels_pre = decoded
        }

        // [String: String] だけを抽出
        for channel in channels_pre {
            channels.append(channel.channelid)
        }

        return channels
    }
}
