import SwiftUI


struct TimersSelect: View {
    var timer:Int
    var set:Int
    var up:Bool
    
    @State private var selectedtimer: TimerType = TimerType(rawValue: UserDefaults.standard.string(forKey: "timertype") ?? "") ?? .default
    init(timer: Int,set:Int,up:Bool) {
        self.timer = timer
        self.set = set
        self.up = up
    }
    var body: some View{
        VStack{
            switch selectedtimer {
            case .default:
                MainTimer(timer: timer)
            case .circle:
                circleTimer(timer: timer,settime: set,up: up)
            }
        }
    }
    
}
