import SwiftUI

struct circleTimer: Count {
    var settime:Int = 0
    var timer:Int
    var hours:Int
    var minutes:Int
    var seconds:Int
    var CGTimer:CGFloat = 1
    var up:Bool = false
    let colors: [Color] = [.blue, .red, .green, .purple, .orange]
    
    var precurrntposition:Int = 0
    var currntposition:Int = 0
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
        self.up = up
        if up {
            self.CGTimer = CGFloat(self.timer+1) / CGFloat(self.settime)
        } else {
            self.CGTimer = CGFloat(self.timer-1) / CGFloat(self.settime)
        }
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
                ForEach(0..<100) { num in
                    if(timer/3600 >= num) {
                        Circle()
                            .trim(from: 0, to: CGTimer - CGFloat(num))
                            .stroke(lineWidth: 20.0)
                            .frame(width: 250, height: 250)
                            .foregroundColor(colors[num%6])
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.easeInOut(duration: 1.5), value: CGTimer - CGFloat(num))
                    }
                }
            } else {
                Circle()
                    .trim(from: 0, to: CGTimer)
                    .stroke(lineWidth: 20.0)
                    .frame(width: 250, height: 250)
                    .foregroundColor(colors[currntposition])
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.easeInOut(duration: 1.5), value: CGTimer)
            }
            
            Text(String(format: "%02dh%02dm%02ds", hours, minutes, seconds))
                .contentTransition(.numericText(value: Double(hours)))
                .contentTransition(.numericText(value: Double(minutes)))
                .contentTransition(.numericText(value: Double(seconds)))
                .font(.title2)
                .fontWeight(.bold)
        }
    }
    
}
