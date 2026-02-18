import SwiftUI

// MARK: - Animated Feature Card
struct AnimatedFeatureCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: LinearGradient
    var action: () -> Void = {}

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(gradient)
                        .frame(width: 50, height: 50)

                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(title)
                        .font(AppTypography.englishSubtitle)
                        .foregroundStyle(.primary)

                    Text(subtitle)
                        .font(AppTypography.englishCaption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.large)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.large)
                    .stroke(gradient.opacity(0.2), lineWidth: 1)
            )
            .islamicShadow()
        }
        .buttonStyle(SpringButtonStyle())
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let title: String
    let arabicTitle: String
    let icon: String
    let count: Int
    let gradient: LinearGradient
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                        .fill(gradient)
                        .frame(width: 56, height: 56)

                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                }

                Text(arabicTitle)
                    .font(.system(size: 16, weight: .bold, design: .serif))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(title)
                    .font(AppTypography.englishSmall)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Text("\(count)")
                    .font(AppTypography.englishCaption)
                    .foregroundStyle(IslamicColors.primaryGreenFallback)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(IslamicColors.primaryGreenFallback.opacity(0.1))
                    )
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.large)
                    .fill(Color(.systemBackground))
            )
            .islamicShadow()
        }
        .buttonStyle(SpringButtonStyle())
    }
}

// MARK: - Info Badge
struct InfoBadge: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(IslamicColors.primaryGreenFallback)

            Text(value)
                .font(AppTypography.englishSubtitle)
                .foregroundStyle(.primary)

            Text(label)
                .font(AppTypography.englishSmall)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Spring Button Style
struct SpringButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Bounce Button Style
struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 20) {
        AnimatedFeatureCard(
            title: "Morning Azkar",
            subtitle: "Start your day with remembrance",
            icon: "sun.and.horizon.fill",
            gradient: AppGradients.islamicGreen
        )

        HStack {
            CategoryCard(
                title: "Morning",
                arabicTitle: "الصباح",
                icon: "sunrise.fill",
                count: 12,
                gradient: AppGradients.islamicGreen
            )

            CategoryCard(
                title: "Evening",
                arabicTitle: "المساء",
                icon: "sunset.fill",
                count: 10,
                gradient: AppGradients.tealWave
            )
        }
    }
    .padding()
}
