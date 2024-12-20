import SwiftUI

var darkBlue = Color(hex: "1E90FF")
var mediumBlue = Color(hex: "63B8FF")
var lightBlue = Color(hex: "B0E2FF")

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

var ButtonColor = Color(hex: "e0ffff")


