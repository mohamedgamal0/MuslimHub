import SwiftUI

struct PrayerTimesHomeView: View {
    @State private var viewModel = PrayerTimesViewModel()
    @State private var showQibla = false
    @State private var showTracking = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    headerCard
                    dateSection
                    prayerTimesList
                    trackingPreview
                }
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
            .refreshable {
                viewModel.calculatePrayerTimes()
            }
            .background(Color(.systemGroupedBackground))
            .onAppear {
                viewModel.requestLocation()
                viewModel.updateLiveActivityIfNeeded()
            }
            .sheet(isPresented: $showQibla) {
                QiblaView()
            }
            .sheet(isPresented: $showTracking) {
                PrayerTrackingView(viewModel: viewModel)
            }
        }
    }

    // MARK: - Header Card
    private var headerCard: some View {
        ZStack {
            AppGradients.islamicGreen
                .frame(height: 240)
                .overlay(
                    IslamicPatternView(color: .white.opacity(0.06), lineWidth: 0.5)
                )
                .clipShape(
                    UnevenRoundedRectangle(
                        bottomLeadingRadius: AppCornerRadius.extraLarge,
                        bottomTrailingRadius: AppCornerRadius.extraLarge
                    )
                )

            VStack(spacing: AppSpacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(Date().hijriDate)
                            .font(AppTypography.englishCaption)
                            .foregroundStyle(.white.opacity(0.8))

                        Text(Date().gregorianFormatted)
                            .font(AppTypography.englishSmall)
                            .foregroundStyle(.white.opacity(0.6))
                    }

                    Spacer()

                    Button {
                        showQibla = true
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "location.north.fill")
                                .font(.system(size: 20))
                            Text(L10n.qiblaDirection)
                                .font(AppTypography.englishSmall)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.vertical, AppSpacing.sm)
                        .background(
                            Capsule()
                                .fill(.white.opacity(0.15))
                        )
                    }
                }

                if let next = viewModel.nextPrayer {
                    VStack(spacing: AppSpacing.xs) {
                        Text(L10n.nextPrayer)
                            .font(AppTypography.englishCaption)
                            .foregroundStyle(.white.opacity(0.7))

                        Text(next.prayer.localizedName)
                            .font(AppTypography.arabicLarge)
                            .foregroundStyle(.white)

                        Text(next.timeString)
                            .font(.system(size: 36, weight: .light, design: .rounded))
                            .foregroundStyle(IslamicColors.goldFallback)

                        Text(viewModel.timeUntilNextPrayer)
                            .font(AppTypography.englishSubtitle)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }

                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 10))
                    Text(viewModel.locationName)
                        .font(AppTypography.englishSmall)
                }
                .foregroundStyle(.white.opacity(0.6))
            }
            .padding(.horizontal, AppSpacing.lg)
        }
        .fadeIn()
    }

    // MARK: - Date Section
    private var dateSection: some View {
        HStack {
            Text(Date().dayOfWeek)
                .font(AppTypography.englishSubtitle)
                .foregroundStyle(.primary)

            Spacer()

            Button {
                showTracking = true
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 14))
                    Text(L10n.prayerTracking)
                        .font(AppTypography.englishCaption)
                }
                .foregroundStyle(IslamicColors.primaryGreenFallback)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    Capsule()
                        .fill(IslamicColors.primaryGreenFallback.opacity(0.1))
                )
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .slideIn(delay: 0.1, from: .trailing)
    }

    // MARK: - Prayer Times List
    private var prayerTimesList: some View {
        VStack(spacing: AppSpacing.sm) {
            ForEach(Array(viewModel.prayerTimes.enumerated()), id: \.element.id) { index, entry in
                PrayerTimeRow(
                    entry: entry,
                    isCompleted: viewModel.isPrayerCompleted(entry.prayer)
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        viewModel.togglePrayerCompletion(entry.prayer)
                    }
                }
                .slideIn(delay: Double(index) * 0.06, from: .bottom)
            }
        }
        .padding(.horizontal, AppSpacing.md)
    }

    // MARK: - Tracking Preview
    private var trackingPreview: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text(LanguageManager.shared.localized("Today's Progress", arabic: "تقدم اليوم"))
                    .font(AppTypography.englishSubtitle)
                Spacer()
                Text("\(Int(viewModel.todayTracking.completionRate * 100))%")
                    .font(AppTypography.englishSubtitle)
                    .foregroundStyle(IslamicColors.primaryGreenFallback)
            }

            ProgressView(value: viewModel.todayTracking.completionRate)
                .tint(IslamicColors.primaryGreenFallback)
                .scaleEffect(y: 2, anchor: .center)
                .clipShape(Capsule())

            HStack {
                ForEach(Prayer.allCases.filter(\.isPrayer)) { prayer in
                    VStack(spacing: 4) {
                        Image(systemName: viewModel.isPrayerCompleted(prayer) ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 16))
                            .foregroundStyle(viewModel.isPrayerCompleted(prayer)
                                             ? IslamicColors.primaryGreenFallback
                                             : .secondary)

                        Text(prayer.localizedName)
                            .font(.system(size: 9, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(Color(.systemBackground))
        )
        .islamicShadow()
        .padding(.horizontal, AppSpacing.md)
        .slideIn(delay: 0.4, from: .bottom)
    }
}

// MARK: - Prayer Time Row
struct PrayerTimeRow: View {
    let entry: PrayerTimeEntry
    let isCompleted: Bool
    var onToggle: () -> Void

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(entry.isNext
                          ? IslamicColors.primaryGreenFallback
                          : IslamicColors.primaryGreenFallback.opacity(0.1))
                    .frame(width: 44, height: 44)

                Image(systemName: entry.prayer.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(entry.isNext ? .white : IslamicColors.primaryGreenFallback)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.prayer.localizedName)
                    .font(entry.isNext ? AppTypography.englishSubtitle : AppTypography.englishBody)
                    .foregroundStyle(entry.isNext ? IslamicColors.primaryGreenFallback : .primary)

                if entry.isNext {
                    Text(L10n.nextPrayer)
                        .font(AppTypography.englishSmall)
                        .foregroundStyle(IslamicColors.goldFallback)
                }
            }

            Spacer()

            Text(entry.timeString)
                .font(.system(size: entry.isNext ? 20 : 17, weight: entry.isNext ? .bold : .medium, design: .rounded))
                .foregroundStyle(entry.isNext ? IslamicColors.primaryGreenFallback : .primary)

            if entry.prayer.isPrayer {
                Button(action: onToggle) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundStyle(isCompleted ? IslamicColors.primaryGreenFallback : .secondary.opacity(0.4))
                        .symbolEffect(.bounce, value: isCompleted)
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm + 2)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .fill(entry.isNext
                      ? IslamicColors.primaryGreenFallback.opacity(0.06)
                      : Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .stroke(entry.isNext ? IslamicColors.primaryGreenFallback.opacity(0.3) : .clear, lineWidth: 1.5)
        )
        .islamicShadow(entry.isNext ? AppShadow.medium : AppShadow.light)
    }
}

#Preview {
    PrayerTimesHomeView()
}
