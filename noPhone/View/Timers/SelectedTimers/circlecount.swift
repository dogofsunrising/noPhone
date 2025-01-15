import SwiftUI

struct circleTimer: Count {
    var settime:Int = 0
    var timer:Int
    var hours:Int
    var minutes:Int
    var seconds:Int
    var CGTimer:CGFloat = 1
    var up:Bool = false
    init(timer: Int) {
        self.timer = timer
        self.hours = timer / 3600
        self.minutes = (timer % 3600) / 60
        self.seconds = timer % 60
    }
    init(timer: Int, settime: Int,up:Bool) {
        self.init(timer: timer) // 必要なプロパティの初期化

        // settimeが0の場合は3600に設定
        self.settime = (settime == 0) ? 3600 : settime
        self.timer = timer
        self.CGTimer = CGFloat(self.timer-1) / CGFloat(self.settime)
    }

    var body: some View{
        ZStack{
            Circle()
                .trim(from: 0, to: 1)
                .stroke(lineWidth: 20.0)
                .frame(width: 250, height: 250)
                .foregroundColor(.gray)
                .rotationEffect(Angle(degrees: 270.0))
            if(up){
                
            }
            Circle()
                .trim(from: 0, to: CGTimer)
                .stroke(lineWidth: 20.0)
                .frame(width: 250, height: 250)
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeInOut(duration: 1.5), value: CGTimer)
            Text(String(format: "%02dh%02dm%02ds", hours, minutes, seconds))
                .font(.title2)
                .fontWeight(.bold)
        }
    }
    
}
