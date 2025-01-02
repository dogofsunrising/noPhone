import SwiftUI


struct TimersSelect: View {
    var timer:Int
    var set:Int
    var up:Bool
    var time_double:Double
    init(timer: Int,set:Int,up:Bool,time_double:Double) {
        self.timer = timer
        self.set = set
        self.up = up
        self.time_double = time_double
    }
    var body: some View{
        VStack{
            circleTimer(timer: timer,settime: set,time_double:time_double)
                .animation(.easeInOut, value: timer)
        }
    }
    
}
