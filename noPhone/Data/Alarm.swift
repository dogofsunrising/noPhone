import UIKit
import AVFoundation

class SoundPlayer: NSObject {
    
    private let musicData: Data
    private var musicPlayer: AVAudioPlayer?
    
    override init() {
        // 音源データを安全に初期化
        guard let asset = NSDataAsset(name: "music") else {
            fatalError("音源ファイル 'music' が見つかりません")
        }
        self.musicData = asset.data
        super.init()
    }
    
    // 音楽を再生
    func playMusic() {
        do {
            musicPlayer = try AVAudioPlayer(data: musicData)
            musicPlayer?.volume = 0.5 // 初期音量を設定 (例: 50%)
            musicPlayer?.play() // 音楽再生
        } catch {
            print("エラー発生: 音楽を再生できません - \(error.localizedDescription)")
        }
    }
    
    // 音楽を停止
    func stopAllMusic() {
        musicPlayer?.stop()
    }
    
    // 音量を調整 (0.0 〜 1.0 の範囲)
    func setVolume(_ volume: Float) {
        guard (0.0...1.0).contains(volume) else {
            print("音量は 0.0 から 1.0 の間で指定してください")
            return
        }
        musicPlayer?.volume = volume
    }
}
