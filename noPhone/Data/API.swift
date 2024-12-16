import Foundation
import Alamofire

public final class API {
    let urlString = "https://6fqsnu3hec.execute-api.ap-northeast-1.amazonaws.com/kouno"
    private var channelid:String
    private var name:String
    private var time:Int
    private var close:Bool
    
    public init(channelid:String ,name:String, time:Int, close:Bool){
        self.channelid = channelid
        self.name = name
        self.time = time
        self.close = close
    }

    public func postAPI() async -> String? {
        // APIのURLを指定
        let urlString = "https://6fqsnu3hec.execute-api.ap-northeast-1.amazonaws.com/kouno"

        // 送信するJSONデータを作成
        let jsonData: [String: Any] = [
            "channelid": channelid,
            "name": name,
            "close": close,
            "realtimer_seconds": time
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

}
