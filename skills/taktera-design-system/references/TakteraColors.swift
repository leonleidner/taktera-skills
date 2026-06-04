import SwiftUI

/// Taktera Brand Colors – adaptive Light/Dark Mode Unterstützung.
/// Light-Mode-Werte sind 1:1 identisch mit der bestehenden Farbpalette.
extension Color {
    // MARK: - Brand
    static let takteraTeal = Color(hex: "#14919b")        // brand-600 (Primary)
    static let takteraTealLight = Color(hex: "#0a616c")   // brand-800 (dark teal)
    static let takteraCyan = Color(hex: "#54d1db")        // brand-300 (match web)
    
    // MARK: - Background Gradients (adaptive)
    static let bgGradientStart = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "#0f172a"))   // slate-900
            : UIColor(Color(hex: "#E2F1F3"))   // original light
    })
    static let bgGradientEnd = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "#1e293b"))   // slate-800
            : UIColor(Color(hex: "#F8F3ED"))   // original light
    })
    // Keep explicit dark variants for any remaining direct references
    static let bgDarkStart = Color(hex: "#0f172a")        // Dark mode start (slate-900)
    static let bgDarkEnd = Color(hex: "#1e293b")          // Dark mode end (slate-800)
    
    // MARK: - Surface / Cards (adaptive)
    /// Primary card surface – white in light, slate-800 in dark.
    static let cardSurface = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "#1e293b"))
            : .white
    })
    /// Glass surface with opacity – for glassmorphism overlays.
    static let glassSurface = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "#1e293b")).withAlphaComponent(0.5)
            : UIColor.white.withAlphaComponent(0.7)
    })
    // Keep legacy names for backward compatibility
    static let cardLight = Color.white
    static let cardDark = Color(hex: "#1e293b")           // slate-800
    static let glassLight = Color.white.opacity(0.7)
    static let glassDark = Color(hex: "#1e293b").opacity(0.5)
    
    // MARK: - Text (adaptive)
    static let textPrimary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "#f1f5f9"))   // slate-100
            : UIColor(Color(hex: "#0f172a"))   // slate-900
    })
    static let textSecondary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "#94a3b8"))   // slate-400
            : UIColor(Color(hex: "#64748b"))   // slate-500
    })
    static let textTertiary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "#64748b"))   // slate-500
            : UIColor(Color(hex: "#94a3b8"))   // slate-400
    })
    static let textOnBrand = Color.white
    
    // MARK: - Status
    static let statusActive = Color(hex: "#22c55e")       // green-500
    static let statusPending = Color(hex: "#f59e0b")      // amber-500
    static let statusDone = Color(hex: "#94a3b8")         // slate-400
    static let statusUrgent = Color(hex: "#ef4444")       // red-500
    
    // MARK: - Shift Types
    static let shiftSurgery = Color(hex: "#ef4444")       // red
    static let shiftPZR = Color(hex: "#3b82f6")           // blue
    static let shiftMeeting = Color(hex: "#a855f7")       // purple
    static let shiftOther = Color(hex: "#14919b")         // teal (brand)
    
    // MARK: - Helper
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Approximate brightness check for choosing contrasting text color.
    var isLight: Bool {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        let brightness = (r * 299 + g * 587 + b * 114) / 1000
        return brightness > 0.6
    }
}

extension ShapeStyle where Self == Color {
    static var takteraTeal: Color { .takteraTeal }
    static var takteraTealLight: Color { .takteraTealLight }
    static var takteraCyan: Color { .takteraCyan }
    
    static var bgGradientStart: Color { .bgGradientStart }
    static var bgGradientEnd: Color { .bgGradientEnd }
    static var bgDarkStart: Color { .bgDarkStart }
    static var bgDarkEnd: Color { .bgDarkEnd }
    
    static var cardLight: Color { .cardLight }
    static var cardDark: Color { .cardDark }
    static var cardSurface: Color { .cardSurface }
    static var glassLight: Color { .glassLight }
    static var glassDark: Color { .glassDark }
    static var glassSurface: Color { .glassSurface }
    
    static var textPrimary: Color { .textPrimary }
    static var textSecondary: Color { .textSecondary }
    static var textTertiary: Color { .textTertiary }
    static var textOnBrand: Color { .textOnBrand }
    
    static var statusActive: Color { .statusActive }
    static var statusPending: Color { .statusPending }
    static var statusDone: Color { .statusDone }
    static var statusUrgent: Color { .statusUrgent }
    
    static var shiftSurgery: Color { .shiftSurgery }
    static var shiftPZR: Color { .shiftPZR }
    static var shiftMeeting: Color { .shiftMeeting }
    static var shiftOther: Color { .shiftOther }
}
