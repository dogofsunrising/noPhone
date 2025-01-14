import Foundation
import Alamofire

public final class API {
    private var channelid = UserDefaults.standard.string(forKey: "channelid") ?? ""
    private var name = UserDefaults.standard.string(forKey: "username") ?? ""
    private var title = UserDefaults.standard.string(forKey: "title") ?? ""

    public func test_closeAPI(time:Int,close:Bool) async -> String?{ return "test11111"}
    public func closeAPI(time:Int,close:Bool) async -> String? {
        // APIのURLを指定
        let urlString = "https://6fqsnu3hec.execute-api.ap-northeast-1.amazonaws.com/kouno/close"

        // 送信するJSONデータを作成
        let jsonData: [String: Any] = [
            "channelid": channelid,
            "name": name,
            "close": close,
            "realtimer_seconds": time,
            "title": title
        ]

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

    
    public func test_startAPI() {}
    public func startAPI() async {
        // APIのURLを指定
        let urlString = "https://6fqsnu3hec.execute-api.ap-northeast-1.amazonaws.com/kouno/start"

        // 送信するJSONデータを作成
        let jsonData: [String: Any] = [
            "channelid": channelid,
            "name": name,
            "title":title
        ]

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
                            } else {
                                print("Message key not found in response.")
                            }
                        } catch {
                            print("JSON decoding error: \(error.localizedDescription)")
                        }
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
        }
    }
}
