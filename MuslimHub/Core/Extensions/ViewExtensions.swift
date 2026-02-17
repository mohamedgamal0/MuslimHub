import SwiftUI

// MARK: - Islamic Card Modifier
struct IslamicCardModifier: ViewModifier {
    var cornerRadius: CGFloat = AppCornerRadius.large
    var shadowStyle: ShadowStyle = AppShadow.light

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: shadowStyle.color,
                        radius: shadowStyle.radius,
                        x: shadowStyle.x,
                        y: shadowStyle.y
                    )
            )
    }
}

// MARK: - Shimmer Effect
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.3),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    phase = 300
                }
            }
    }
}

// MARK: - Fade In Animation
struct FadeInModifier: ViewModifier {
    @State private var opacity: Double = 0
    let delay: Double

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.5).delay(delay)) {
                    opacity = 1
                }
            }
    }
}

// MARK: - Slide In Animation
struct SlideInModifier: ViewModifier {
    @State private var offset: CGFloat = 50
    @State private var opacity: Double = 0
    let delay: Double
    let direction: Edge

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .offset(
                x: direction == .leading ? -offset : (direction == .trailing ? offset : 0),
                y: direction == .top ? -offset : (direction == .bottom ? offset : 0)
            )
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay)) {
                    offset = 0
                    opacity = 1
                }
            }
    }
}

// MARK: - View Extension Methods
extension View {
    func islamicCard(cornerRadius: CGFloat = AppCornerRadius.large) -> some View {
        modifier(IslamicCardModifier(cornerRadius: cornerRadius))
    }

    func shimmerEffect() -> some View {
        modifier(ShimmerModifier())
    }

    func fadeIn(delay: Double = 0) -> some View {
        modifier(FadeInModifier(delay: delay))
    }

    func slideIn(delay: Double = 0, from direction: Edge = .bottom) -> some View {
        modifier(SlideInModifier(delay: delay, direction: direction))
    }

    func islamicShadow(_ style: ShadowStyle = AppShadow.light) -> some View {
        shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }

    func arabicFont(_ font: Font) -> some View {
        self.font(font)
            .multilineTextAlignment(LanguageManager.shared.currentLanguage.isRTL ? .trailing : .leading)
    }

    func rtlAware() -> some View {
        environment(\.layoutDirection, LanguageManager.shared.layoutDirection)
    }
}
