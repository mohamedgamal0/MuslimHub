import SwiftUI

// MARK: - Islamic Geometric Pattern
struct IslamicPatternView: View {
    var color: Color = IslamicColors.goldFallback.opacity(0.15)
    var lineWidth: CGFloat = 1

    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                let spacing: CGFloat = 40
                let rows = Int(size.height / spacing) + 2
                let cols = Int(size.width / spacing) + 2

                for row in 0..<rows {
                    for col in 0..<cols {
                        let x = CGFloat(col) * spacing
                        let y = CGFloat(row) * spacing

                        let star = createEightPointStar(
                            center: CGPoint(x: x, y: y),
                            outerRadius: spacing * 0.35,
                            innerRadius: spacing * 0.15
                        )

                        context.stroke(
                            star,
                            with: .color(color),
                            lineWidth: lineWidth
                        )
                    }
                }
            }
        }
    }

    private func createEightPointStar(center: CGPoint, outerRadius: CGFloat, innerRadius: CGFloat) -> Path {
        var path = Path()
        let points = 8
        let angleStep = .pi / Double(points)

        for i in 0..<(points * 2) {
            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
            let angle = Double(i) * angleStep - .pi / 2

            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )

            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Decorative Crescent Moon
struct CrescentMoonView: View {
    var size: CGFloat = 60
    var color: Color = IslamicColors.goldFallback

    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: size, height: size)

            Circle()
                .fill(Color(.systemBackground))
                .frame(width: size * 0.75, height: size * 0.75)
                .offset(x: size * 0.15, y: -size * 0.05)
        }
    }
}

// MARK: - Decorative Divider
struct IslamicDivider: View {
    var color: Color = IslamicColors.goldFallback.opacity(0.4)

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Rectangle()
                .fill(color)
                .frame(height: 1)

            Image(systemName: "star.fill")
                .font(.system(size: 8))
                .foregroundStyle(color)

            Diamond()
                .fill(color)
                .frame(width: 8, height: 8)

            Image(systemName: "star.fill")
                .font(.system(size: 8))
                .foregroundStyle(color)

            Rectangle()
                .fill(color)
                .frame(height: 1)
        }
        .padding(.horizontal, AppSpacing.md)
    }
}

// MARK: - Diamond Shape
struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Mosque Silhouette Header
struct MosqueSilhouetteView: View {
    var color: Color = IslamicColors.primaryGreenFallback

    var body: some View {
        ZStack(alignment: .bottom) {
            AppGradients.islamicGreen
                .frame(height: 200)
                .clipShape(
                    UnevenRoundedRectangle(
                        bottomLeadingRadius: AppCornerRadius.extraLarge,
                        bottomTrailingRadius: AppCornerRadius.extraLarge
                    )
                )

            IslamicPatternView(color: .white.opacity(0.08), lineWidth: 0.5)
                .frame(height: 200)
                .clipShape(
                    UnevenRoundedRectangle(
                        bottomLeadingRadius: AppCornerRadius.extraLarge,
                        bottomTrailingRadius: AppCornerRadius.extraLarge
                    )
                )
        }
    }
}

// MARK: - Animated Prayer Ring
struct PrayerRingView: View {
    let progress: Double
    var lineWidth: CGFloat = 6
    var size: CGFloat = 60
    var gradient: LinearGradient = AppGradients.islamicGreen

    @State private var animatedProgress: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.15), lineWidth: lineWidth)
                .frame(width: size, height: size)

            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(gradient, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.easeOut(duration: 0.5)) {
                animatedProgress = newValue
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        IslamicPatternView()
            .frame(height: 100)

        CrescentMoonView()

        IslamicDivider()

        PrayerRingView(progress: 0.7)
    }
}
