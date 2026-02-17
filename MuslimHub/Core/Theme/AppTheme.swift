import SwiftUI

// MARK: - Islamic Color Palette
enum IslamicColors {
    static let primaryGreen = Color("PrimaryGreen", bundle: nil)
    static let darkGreen = Color("DarkGreen", bundle: nil)
    static let gold = Color("GoldAccent", bundle: nil)
    static let cream = Color("CreamBackground", bundle: nil)
    static let teal = Color("TealAccent", bundle: nil)

    static let primaryGreenFallback = Color(red: 0.106, green: 0.420, blue: 0.302)
    static let darkGreenFallback = Color(red: 0.059, green: 0.255, blue: 0.180)
    static let goldFallback = Color(red: 0.769, green: 0.639, blue: 0.353)
    static let creamFallback = Color(red: 0.992, green: 0.973, blue: 0.941)
    static let tealFallback = Color(red: 0.165, green: 0.616, blue: 0.561)

    static let cardBackground = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)
}

// MARK: - Typography
enum AppTypography {
    static let arabicTitle = Font.system(size: 28, weight: .bold, design: .serif)
    static let arabicBody = Font.system(size: 22, weight: .regular, design: .serif)
    static let arabicAyah = Font.system(size: 26, weight: .regular, design: .serif)
    static let arabicLarge = Font.system(size: 32, weight: .bold, design: .serif)

    static let englishTitle = Font.system(size: 24, weight: .bold, design: .rounded)
    static let englishSubtitle = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let englishBody = Font.system(size: 16, weight: .regular, design: .rounded)
    static let englishCaption = Font.system(size: 14, weight: .regular, design: .rounded)
    static let englishSmall = Font.system(size: 12, weight: .regular, design: .rounded)

    static let tabLabel = Font.system(size: 10, weight: .medium, design: .rounded)
}

// MARK: - Spacing
enum AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius
enum AppCornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let extraLarge: CGFloat = 24
    static let pill: CGFloat = 50
}

// MARK: - Shadow
struct AppShadow {
    static let light = ShadowStyle(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    static let medium = ShadowStyle(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
    static let heavy = ShadowStyle(color: .black.opacity(0.18), radius: 16, x: 0, y: 8)
}

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Gradient Presets
enum AppGradients {
    static let islamicGreen = LinearGradient(
        colors: [
            IslamicColors.primaryGreenFallback,
            IslamicColors.darkGreenFallback
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let goldShimmer = LinearGradient(
        colors: [
            IslamicColors.goldFallback.opacity(0.8),
            IslamicColors.goldFallback,
            IslamicColors.goldFallback.opacity(0.8)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let tealWave = LinearGradient(
        colors: [
            IslamicColors.tealFallback,
            IslamicColors.primaryGreenFallback
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let warmBackground = LinearGradient(
        colors: [
            IslamicColors.creamFallback,
            Color(.systemBackground)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let cardGlow = LinearGradient(
        colors: [
            IslamicColors.primaryGreenFallback.opacity(0.1),
            IslamicColors.tealFallback.opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
