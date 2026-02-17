import SwiftUI

struct PrayerTimesHomeView: View {
    @State private var viewModel = PrayerTimesViewModel()
    @State private var showQibla = false
    @State private var showTracking = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    headerCard
                    dateSection
                    trackingPreview
                    prayerTimesList
                }
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
            .refreshable {
                viewModel.calculatePrayerTimes()
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(.systemGroupedBackground),
                        Color(.systemGroupedBackground).opacity(0.98)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea(edges: .top)
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

    // MARK: - Header Card (edge-to-edge, fills from status bar)
    private var headerCard: some View {
        ZStack(alignment: .top) {
            AppGradients.islamicGreen
                .frame(height: 260 + 56)
                .frame(maxWidth: .infinity)
                .overlay(
                    IslamicPatternView(color: .white.opacity(0.06), lineWidth: 0.5)
                )
                .overlay(
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.08)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(
                    UnevenRoundedRectangle(
                        bottomLeadingRadius: AppCornerRadius.extraLarge,
                        bottomTrailingRadius: AppCornerRadius.extraLarge
                    )
                )
                .ignoresSafeArea(edges: .top)

            VStack(spacing: AppSpacing.lg) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(Date().hijriDate)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.85))

                        Text(Date().gregorianFormatted)
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundStyle(.white.opacity(0.65))
                    }

                    Spacer()

                    Button {
                        showQibla = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "location.north.fill")
                                .font(.system(size: 14, weight: .semibold))
                            Text(L10n.qiblaDirection)
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.vertical, AppSpacing.sm + 2)
                        .background(.ultraThinMaterial, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }

                if let next = viewModel.nextPrayer {
                    VStack(spacing: 6) {
                        Text(L10n.nextPrayer)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.75))

                        Text(next.prayer.localizedName)
                            .font(AppTypography.arabicLarge)
                            .foregroundStyle(.white)

                        Text(next.timeString)
                            .font(.system(size: 34, weight: .light, design: .rounded))
                            .foregroundStyle(IslamicColors.goldFallback)

                        Text(viewModel.timeUntilNextPrayer)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }

                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 11))
                    Text(viewModel.locationName)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }
                .foregroundStyle(.white.opacity(0.65))
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, 56 + AppSpacing.md)
            .padding(.bottom, AppSpacing.md)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 260 + 56)
        .fadeIn()
    }

    // MARK: - Date Section
    private var dateSection: some View {
        HStack {
            Text(Date().dayOfWeek)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(.primary)

            Spacer()

            Button {
                showTracking = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 13))
                    Text(L10n.prayerTracking)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                }
                .foregroundStyle(IslamicColors.primaryGreenFallback)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm + 2)
                .background(
                    Capsule()
                        .fill(IslamicColors.primaryGreenFallback.opacity(0.12))
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, AppSpacing.lg)
        .slideIn(delay: 0.1, from: .trailing)
    }

    // MARK: - Prayer Times List
    private var prayerTimesList: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(LanguageManager.shared.localized("Prayer Times", arabic: "أوقات الصلاة"))
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .padding(.horizontal, AppSpacing.sm)

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
                    .slideIn(delay: Double(index) * 0.05, from: .bottom)
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
    }

    // MARK: - Tracking Preview
    private var trackingPreview: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            HStack(alignment: .center) {
                Text(LanguageManager.shared.localized("Today's Progress", arabic: "تقدم اليوم"))
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                Spacer()
                Text("\(Int(viewModel.todayTracking.completionRate * 100))%")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(IslamicColors.primaryGreenFallback)
            }

            ProgressView(value: viewModel.todayTracking.completionRate)
                .tint(IslamicColors.primaryGreenFallback)
                .scaleEffect(y: 2.2, anchor: .center)
                .clipShape(Capsule())

            HStack(spacing: 0) {
                ForEach(Prayer.allCases.filter(\.isPrayer)) { prayer in
                    VStack(spacing: 6) {
                        Image(systemName: viewModel.isPrayerCompleted(prayer) ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 18))
                            .foregroundStyle(viewModel.isPrayerCompleted(prayer)
                                             ? IslamicColors.primaryGreenFallback
                                             : Color(.tertiaryLabel))
                            .symbolEffect(.bounce, value: viewModel.isPrayerCompleted(prayer))

                        Text(prayer.localizedName)
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large + 4)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
        )
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
                          : IslamicColors.primaryGreenFallback.opacity(0.12))
                    .frame(width: 48, height: 48)

                Image(systemName: entry.prayer.icon)
                    .font(.system(size: 20, weight: entry.isNext ? .semibold : .regular))
                    .foregroundStyle(entry.isNext ? .white : IslamicColors.primaryGreenFallback)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(entry.prayer.localizedName)
                    .font(.system(size: entry.isNext ? 17 : 16, weight: entry.isNext ? .semibold : .medium, design: .rounded))
                    .foregroundStyle(entry.isNext ? IslamicColors.primaryGreenFallback : .primary)

                if entry.isNext {
                    Text(L10n.nextPrayer)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(IslamicColors.goldFallback)
                }
            }

            Spacer()

            Text(entry.timeString)
                .font(.system(size: entry.isNext ? 18 : 16, weight: entry.isNext ? .bold : .semibold, design: .rounded))
                .foregroundStyle(entry.isNext ? IslamicColors.primaryGreenFallback : .primary)

            if entry.prayer.isPrayer {
                Button(action: onToggle) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 26))
                        .foregroundStyle(isCompleted ? IslamicColors.primaryGreenFallback : Color(.tertiaryLabel))
                        .symbolEffect(.bounce, value: isCompleted)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(entry.isNext
                      ? IslamicColors.primaryGreenFallback.opacity(0.08)
                      : Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .stroke(entry.isNext ? IslamicColors.primaryGreenFallback.opacity(0.25) : .clear, lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(entry.isNext ? 0.08 : 0.05), radius: entry.isNext ? 10 : 6, x: 0, y: 3)
    }
}

#Preview {
    PrayerTimesHomeView()
}
