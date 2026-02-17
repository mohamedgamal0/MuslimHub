import SwiftUI

struct PrayerTrackingView: View {
    let viewModel: PrayerTimesViewModel
    @Environment(\.dismiss) private var dismiss

    private let prayers = Prayer.allCases.filter(\.isPrayer)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    weeklyOverview
                    todayDetail
                    weeklyChart
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.xxl)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle(L10n.prayerTracking)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Weekly Overview
    private var weeklyOverview: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(LanguageManager.shared.localized("Weekly Progress", arabic: "التقدم الأسبوعي"))
                        .font(AppTypography.englishSubtitle)

                    Text("\(Int(viewModel.weeklyCompletionRate * 100))% \(LanguageManager.shared.localized("completion", arabic: "إتمام"))")
                        .font(AppTypography.englishCaption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                PrayerRingView(
                    progress: viewModel.weeklyCompletionRate,
                    lineWidth: 6,
                    size: 60,
                    gradient: AppGradients.islamicGreen
                )
                .overlay {
                    Text("\(Int(viewModel.weeklyCompletionRate * 100))%")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(IslamicColors.primaryGreenFallback)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(Color(.systemBackground))
        )
        .islamicShadow()
        .fadeIn()
    }

    // MARK: - Today Detail
    private var todayDetail: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(LanguageManager.shared.localized("Today", arabic: "اليوم"))
                .font(AppTypography.englishSubtitle)

            ForEach(prayers) { prayer in
                HStack {
                    Image(systemName: prayer.icon)
                        .font(.system(size: 18))
                        .foregroundStyle(IslamicColors.primaryGreenFallback)
                        .frame(width: 30)

                    Text(prayer.localizedName)
                        .font(AppTypography.englishBody)

                    Spacer()

                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            viewModel.togglePrayerCompletion(prayer)
                        }
                    } label: {
                        Image(systemName: viewModel.isPrayerCompleted(prayer)
                              ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 24))
                            .foregroundStyle(viewModel.isPrayerCompleted(prayer)
                                             ? IslamicColors.primaryGreenFallback
                                             : .secondary.opacity(0.4))
                            .symbolEffect(.bounce, value: viewModel.isPrayerCompleted(prayer))
                    }
                }
                .padding(.vertical, AppSpacing.xs)

                if prayer != prayers.last {
                    Divider()
                }
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(Color(.systemBackground))
        )
        .islamicShadow()
        .slideIn(delay: 0.1, from: .bottom)
    }

    // MARK: - Weekly Chart
    private var weeklyChart: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(LanguageManager.shared.localized("This Week", arabic: "هذا الأسبوع"))
                .font(AppTypography.englishSubtitle)

            HStack(alignment: .bottom, spacing: AppSpacing.sm) {
                ForEach(last7Days(), id: \.self) { date in
                    VStack(spacing: 4) {
                        let rate = completionRate(for: date)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(rate > 0
                                  ? AppGradients.islamicGreen
                                  : LinearGradient(colors: [Color.gray.opacity(0.2)],
                                                   startPoint: .bottom, endPoint: .top))
                            .frame(width: 32, height: max(8, CGFloat(rate) * 100))
                            .animation(.spring(response: 0.5), value: rate)

                        Text(dayLabel(date))
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 130, alignment: .bottom)
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(Color(.systemBackground))
        )
        .islamicShadow()
        .slideIn(delay: 0.2, from: .bottom)
    }

    // MARK: - Helpers
    private func last7Days() -> [Date] {
        (0..<7).compactMap { offset in
            Calendar.current.date(byAdding: .day, value: -6 + offset, to: Date())
        }
    }

    private func completionRate(for date: Date) -> Double {
        let calendar = Calendar.current
        return viewModel.trackingDays
            .first(where: { calendar.isDate($0.date, inSameDayAs: date) })?
            .completionRate ?? 0
    }

    private func dayLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

#Preview {
    PrayerTrackingView(viewModel: PrayerTimesViewModel())
}
