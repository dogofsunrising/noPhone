import SwiftUI

var darkBlue = Color(hex: "1E90FF")
var mediumBlue = Color(hex: "63B8FF")
var lightBlue = Color(hex: "B0E2FF")
// TODO: リストの赤色をもっと暗くしたい
var lightPink = Color(hex: "ffc0cb")

extension Color {
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
    }
}
enum HowColor {
    case button
    case text
    case `default`
    
}

func ButtonColor(how:HowColor, scheme: ColorScheme) -> Color {
    switch how {
    case .button:
        return scheme == .dark ? Color(hex: "000080") : Color(hex: "e0ffff") // TODO: ダークモードの青が暗すぎる
    case .text:
        return scheme == .dark ? Color(hex: "ffffff") : Color(hex: "1E90FF")
    case .default:
        return scheme == .dark ? Color(hex: "ffffff") : Color(hex: "000000")
    }
    
}



