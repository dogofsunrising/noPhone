import SwiftUI


struct TimersSelect: View {
    var timer:Int
    var set:Int
    var up:Bool
    init(timer: Int,set:Int,up:Bool) {
        self.timer = timer
        self.set = set
        self.up = up
    }
    var body: some View{
        VStack{
            circleTimer(timer: timer,settime: set,up: up)
               
        }
    }
    
}
