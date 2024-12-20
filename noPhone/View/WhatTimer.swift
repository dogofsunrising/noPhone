import SwiftUI

struct WhatTimer: View {
    private let timer:Int
    private var hours:Int = 0
    private var minutes:Int = 0
    private var seconds:Int = 0
    init(timer: Int) {
        self.timer = timer
        self.hours = timer / 3600
        self.minutes = (timer % 3600) / 60
        self.seconds = timer % 60
    }
    var body: some View{
        VStack{
            Text(String(format: "%02dh%02dm%02ds", hours, minutes, seconds))
                .font(.title2)
                .fontWeight(.bold)
        }
    }
    
}

struct WhatTimer2: View {
    private let timer:Int
    private var hours:Int = 0
    private var minutes:Int = 0
    private var seconds:Int = 0
    init(timer: Int) {
        self.timer = timer
        self.hours = timer / 3600
        self.minutes = (timer % 3600) / 60
        self.seconds = timer % 60
    }
    var body: some View{
        VStack{
            Text(String(format: "%02dh%02dm%02ds", hours, minutes, seconds))
                .font(.largeTitle)
                .fontWeight(.bold)
        }
    }
    
}
