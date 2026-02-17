import SwiftUI
import CoreLocation

struct QiblaView: View {
    @State private var locationService = LocationService.shared
    @State private var animatedRotation: Double = 0
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.xl) {
                Spacer()

                qiblaInfo
                compassView
                directionInfo

                Spacer()
            }
            .padding()
            .background(
                AppGradients.islamicGreen
                    .ignoresSafeArea()
                    .overlay(
                        IslamicPatternView(color: .white.opacity(0.04), lineWidth: 0.5)
                            .ignoresSafeArea()
                    )
            )
            .navigationTitle(L10n.qiblaDirection)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
            }
            .onAppear {
                locationService.requestPermission()
                locationService.startUpdatingLocation()
                locationService.startUpdatingHeading()
            }
            .onDisappear {
                locationService.stopUpdatingHeading()
            }
            .onChange(of: locationService.qiblaRelativeToNorth) { _, newValue in
                withAnimation(.easeInOut(duration: 0.3)) {
                    animatedRotation = newValue
                }
            }
        }
    }

    // MARK: - Qibla Info
    private var qiblaInfo: some View {
        VStack(spacing: AppSpacing.sm) {
            CrescentMoonView(size: 40, color: IslamicColors.goldFallback)

            Text("🕋")
                .font(.system(size: 30))

            Text(L10n.qiblaDirection)
                .font(AppTypography.englishTitle)
                .foregroundStyle(.white)

            Text(LanguageManager.shared.localized(
                "Point your device towards Qibla",
                arabic: "وجّه جهازك نحو القبلة"
            ))
            .font(AppTypography.englishCaption)
            .foregroundStyle(.white.opacity(0.7))
        }
        .fadeIn()
    }

    // MARK: - Compass
    private var compassView: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.15), lineWidth: 2)
                .frame(width: 280, height: 280)

            Circle()
                .fill(.white.opacity(0.05))
                .frame(width: 280, height: 280)

            ForEach(0..<72) { i in
                Rectangle()
                    .fill(.white.opacity(i % 9 == 0 ? 0.5 : 0.15))
                    .frame(width: i % 9 == 0 ? 2 : 1, height: i % 9 == 0 ? 15 : 8)
                    .offset(y: -130)
                    .rotationEffect(.degrees(Double(i) * 5))
            }

            ForEach(["N", "E", "S", "W"], id: \.self) { direction in
                Text(direction)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white.opacity(0.6))
                    .offset(y: -110)
                    .rotationEffect(.degrees(
                        direction == "N" ? 0 :
                        direction == "E" ? 90 :
                        direction == "S" ? 180 : 270
                    ))
            }

            VStack(spacing: 0) {
                Image(systemName: "arrowtriangle.up.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(IslamicColors.goldFallback)
                    .shadow(color: IslamicColors.goldFallback.opacity(0.5), radius: 10)

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [IslamicColors.goldFallback, IslamicColors.goldFallback.opacity(0.3)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 3, height: 80)
            }
            .offset(y: -40)
            .rotationEffect(.degrees(animatedRotation))

            Circle()
                .fill(IslamicColors.goldFallback)
                .frame(width: 16, height: 16)
                .shadow(color: IslamicColors.goldFallback.opacity(0.5), radius: 5)
        }
        .fadeIn(delay: 0.2)
    }

    // MARK: - Direction Info
    private var directionInfo: some View {
        VStack(spacing: AppSpacing.sm) {
            HStack(spacing: AppSpacing.lg) {
                VStack {
                    Text(String(format: "%.1f°", locationService.qiblaDirection))
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(IslamicColors.goldFallback)

                    Text(LanguageManager.shared.localized("Qibla Bearing", arabic: "اتجاه القبلة"))
                        .font(AppTypography.englishSmall)
                        .foregroundStyle(.white.opacity(0.6))
                }

                Rectangle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 1, height: 40)

                VStack {
                    Text(String(format: "%.1f°", locationService.heading?.magneticHeading ?? 0))
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text(LanguageManager.shared.localized("Device Heading", arabic: "اتجاه الجهاز"))
                        .font(AppTypography.englishSmall)
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(.white.opacity(0.1))
        )
        .fadeIn(delay: 0.3)
    }
}

#Preview {
    QiblaView()
}
