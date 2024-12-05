import Foundation

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
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // 送信するJSONデータを作成
        let jsonData: [String: Any] = [
            "channelid": channelid,
            "name": name
        ]
        
        // JSONデータをData型に変換
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonData, options: []) else {
            print("Failed to serialize JSON data")
            return
        }
        
        // URLリクエストを作成
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        // URLSessionでリクエストを送信
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // レスポンスデータをJSONとして解析
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Success: \(jsonResponse)")
                }
            } catch {
                print("Failed to parse JSON response: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
