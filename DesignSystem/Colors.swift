import SwiftUI

extension Color {
    static let backgroundPrimary = Color(hex: "#FFFFFF")
    static let surfacePrimary = Color(hex: "#F7F7F8")
    static let borderPrimary = Color(hex: "#E5E7EB")

    static let textPrimary = Color(hex: "#111827")
    static let textSecondary = Color(hex: "#4B5563")
    static let textTertiary = Color(hex: "#9CA3AF")

    static let accentPrimary = Color(hex: "#2563EB")
    static let accentDanger = Color(hex: "#DC2626")
    static let accentSuccess = Color(hex: "#16A34A")
    static let accentWarning = Color(hex: "#F59E0B")

    static let categoryBlue = Color(hex: "#3B82F6")
    static let categoryGreen = Color(hex: "#22C55E")
    static let categoryYellow = Color(hex: "#EAB308")
    static let categoryOrange = Color(hex: "#F97316")
    static let categoryPink = Color(hex: "#EC4899")
    static let categoryPurple = Color(hex: "#8B5CF6")

    static let categoryPalette: [Color] = [
        .categoryBlue,
        .categoryGreen,
        .categoryYellow,
        .categoryOrange,
        .categoryPink,
        .categoryPurple
    ]

    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)

        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double

        switch cleaned.count {
        case 6:
            red = Double((value >> 16) & 0xFF) / 255.0
            green = Double((value >> 8) & 0xFF) / 255.0
            blue = Double(value & 0xFF) / 255.0
            alpha = 1.0
        case 8:
            red = Double((value >> 24) & 0xFF) / 255.0
            green = Double((value >> 16) & 0xFF) / 255.0
            blue = Double((value >> 8) & 0xFF) / 255.0
            alpha = Double(value & 0xFF) / 255.0
        default:
            red = 0
            green = 0
            blue = 0
            alpha = 1.0
        }

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
