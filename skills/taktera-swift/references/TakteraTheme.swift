import SwiftUI

/// Design-System Tokens für die Taktera App.
enum TakteraTheme {
    
    // MARK: - Typography
    
    static let titleFont: Font = .system(size: 28, weight: .bold)
    static let headlineFont: Font = .system(size: 20, weight: .semibold)
    static let subheadFont: Font = .system(size: 16, weight: .medium)
    static let bodyFont: Font = .system(size: 15, weight: .regular)
    static let captionFont: Font = .system(size: 12, weight: .medium)
    static let labelFont: Font = .system(size: 12, weight: .bold).uppercaseSmallCaps()
    
    // MARK: - Spacing
    
    static let spacingXS: CGFloat = 4
    static let spacingSM: CGFloat = 8
    static let spacingMD: CGFloat = 16
    static let spacingLG: CGFloat = 24
    static let spacingXL: CGFloat = 32
    static let spacing2XL: CGFloat = 48
    
    // MARK: - Corner Radius
    
    static let radiusSM: CGFloat = 8
    static let radiusMD: CGFloat = 12
    static let radiusLG: CGFloat = 16
    static let radiusXL: CGFloat = 24
    static let radiusFull: CGFloat = 9999
    
    // MARK: - Shadows
    
    static let shadowLight = ShadowStyle.drop(
        color: .black.opacity(0.06),
        radius: 8,
        x: 0,
        y: 4
    )
    
    static let shadowMedium = ShadowStyle.drop(
        color: .black.opacity(0.1),
        radius: 12,
        x: 0,
        y: 4
    )
}

// MARK: - View Modifiers

/// Glassmorphism Card Style
struct GlassCard: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: TakteraTheme.radiusXL)
                    .fill(Color.glassSurface)
                    .background {
                        RoundedRectangle(cornerRadius: TakteraTheme.radiusXL)
                            .fill(.ultraThinMaterial)
                    }
            }
            .overlay {
                RoundedRectangle(cornerRadius: TakteraTheme.radiusXL)
                    .strokeBorder(
                        colorScheme == .dark
                            ? Color.white.opacity(0.1)
                            : Color.white.opacity(0.8),
                        lineWidth: 1
                    )
            }
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 8, y: 4)
    }
}

/// Teal gradient button style
struct TakteraButtonStyle: ButtonStyle {
    var backgroundColor: Color = .takteraTeal

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: TakteraTheme.radiusLG))
            .shadow(color: backgroundColor.opacity(0.3), radius: 16, y: 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

/// Minimal press-feedback button style for cards (no full restyle)
struct PressFeedbackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension View {
    func glassCard() -> some View {
        modifier(GlassCard())
    }
}
