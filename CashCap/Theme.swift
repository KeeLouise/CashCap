import SwiftUI

extension Color {
    static let luxeBackground = Color(red: 17/255, green: 24/255, blue: 39/255)  // #111827
    static let luxeCard = Color(red: 31/255, green: 41/255, blue: 55/255)        // #1F2937
    static let luxeLime = Color(red: 163/255, green: 230/255, blue: 53/255)      // #A3E635
    static let luxeRed = Color(red: 252/255, green: 165/255, blue: 165/255)      // #FCA5A5
}

//the app's one currency: write `format: .appCurrency` instead of repeating "EUR" everywhere
extension FormatStyle where Self == FloatingPointFormatStyle<Double>.Currency {
    static var appCurrency: Self { .currency(code: "EUR") }
}
