import Foundation
import Alamofire

public final class API {
    let urlString = "https://6fqsnu3hec.execute-api.ap-northeast-1.amazonaws.com/kouno"
    private var channelid:String
    private var name:String
    
    public init(channelid:String ,name:String){
        self.channelid = channelid
        self.name = name
    }

    public func postAPI() {
        // APIのURLを指定
        let urlString = "https://6fqsnu3hec.execute-api.ap-northeast-1.amazonaws.com/kouno"
        
        // 送信するJSONデータを作成
        let jsonData: [String: Any] = [
            "channelid": channelid,
            "name": name
        ]
        
        // Alamofireを使用してPOSTリクエストを送信
        AF.request(urlString, method: .post, parameters: jsonData, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .responseData { response in
                switch response.result {
                case .success(let value):
                        print("Success: \(value)")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
    }

}
