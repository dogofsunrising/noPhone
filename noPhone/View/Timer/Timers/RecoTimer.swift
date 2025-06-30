import SwiftUI

struct RecoTimer: View {
    private let timer: Int
    private let hours: Int
    private let minutes: Int
    private let seconds: Int
    
    private enum CloseState {
        case trueState
        case falseState
        case neutral
    }
    private let closeState: CloseState
    
    init(timer: Int, close: Bool, on: Bool) {
        self.timer = timer
        self.hours = timer / 3600
        self.minutes = (timer % 3600) / 60
        self.seconds = timer % 60
        if on {
            self.closeState = close ? .trueState : .falseState
        } else {
            self.closeState = .neutral
        }
    }
    
    private var formattedTime: String {
        if(hours == 0 && minutes == 0 && seconds == 0 && closeState == .neutral){
            String("設定なし")
        } else{
            String(format: "%02dh%02dm%02ds", hours, minutes, seconds)
        }
    }
    
    private var textColor: Color {
        switch closeState {
        case .trueState:
            return .blue
        case .falseState:
            return .red
        case .neutral:
            return .primary
        }
    }
    
    var body: some View {
        Text(formattedTime)
            .foregroundColor(textColor)
    }
}


