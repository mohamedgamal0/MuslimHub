import SwiftUI

struct DoaaDetailView: View {
    let doaa: Doaa
    let viewModel: DoaaViewModel
    @State private var currentCount = 0
    @State private var showCompletion = false
    @Environment(\.dismiss) private var dismiss

    private var progress: Double {
        guard doaa.repeatCount > 0 else { return 0 }
        return Double(currentCount) / Double(doaa.repeatCount)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    counterSection
                    arabicTextSection
                    transliterationSection
                    translationSection
                    sourceSection
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.xxl)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle(doaa.category.localizedName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.toggleFavorite(doaa)
                    } label: {
                        Image(systemName: doaa.isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(doaa.isFavorite ? .red : .secondary)
                    }
                }
            }
            .overlay {
                if showCompletion {
                    completionOverlay
                }
            }
        }
    }

    // MARK: - Counter Section
    private var counterSection: some View {
        VStack(spacing: AppSpacing.md) {
            ZStack {
                PrayerRingView(
                    progress: progress,
                    lineWidth: 8,
                    size: 120,
                    gradient: AppGradients.islamicGreen
                )

                VStack(spacing: 2) {
                    Text("\(currentCount)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(IslamicColors.primaryGreenFallback)
                        .contentTransition(.numericText())

                    Text("/ \(doaa.repeatCount)")
                        .font(AppTypography.englishCaption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.top, AppSpacing.md)

            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    if currentCount < doaa.repeatCount {
                        currentCount += 1
                    }
                    if currentCount >= doaa.repeatCount {
                        showCompletion = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { showCompletion = false }
                        }
                    }
                }
            } label: {
                Text(L10n.repeatCount)
                    .font(AppTypography.englishSubtitle)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                    .background(
                        Capsule()
                            .fill(AppGradients.islamicGreen)
                    )
            }
            .buttonStyle(BounceButtonStyle())
            .padding(.horizontal, AppSpacing.xxl)

            Button {
                withAnimation {
                    currentCount = 0
                }
            } label: {
                Text("Reset")
                    .font(AppTypography.englishCaption)
                    .foregroundStyle(.secondary)
            }
        }
        .fadeIn()
    }

    // MARK: - Arabic Text
    private var arabicTextSection: some View {
        VStack(spacing: AppSpacing.sm) {
            Text(doaa.textArabic)
                .font(AppTypography.arabicAyah)
                .multilineTextAlignment(.center)
                .lineSpacing(14)
                .foregroundStyle(.primary)
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(Color(.systemBackground))
        )
        .islamicShadow()
        .fadeIn(delay: 0.1)
    }

    // MARK: - Transliteration
    @ViewBuilder
    private var transliterationSection: some View {
        if !doaa.transliteration.isEmpty {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Label("Transliteration", systemImage: "character.textbox")
                    .font(AppTypography.englishCaption)
                    .foregroundStyle(.secondary)

                Text(doaa.transliteration)
                    .font(.system(size: 16, weight: .regular, design: .serif))
                    .italic()
                    .foregroundStyle(.primary)
                    .lineSpacing(6)
            }
            .padding(AppSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.large)
                    .fill(IslamicColors.primaryGreenFallback.opacity(0.05))
            )
            .fadeIn(delay: 0.15)
        }
    }

    // MARK: - Translation
    private var translationSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Label("Translation", systemImage: "globe")
                .font(AppTypography.englishCaption)
                .foregroundStyle(.secondary)

            Text(doaa.textEnglish)
                .font(AppTypography.englishBody)
                .foregroundStyle(.primary)
                .lineSpacing(6)
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(Color(.systemBackground))
        )
        .islamicShadow()
        .fadeIn(delay: 0.2)
    }

    // MARK: - Source
    @ViewBuilder
    private var sourceSection: some View {
        if !doaa.source.isEmpty {
            HStack {
                Image(systemName: "book.closed.fill")
                    .foregroundStyle(IslamicColors.goldFallback)
                Text(doaa.source)
                    .font(AppTypography.englishCaption)
                    .foregroundStyle(.secondary)
            }
            .padding(AppSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(IslamicColors.goldFallback.opacity(0.08))
            )
            .fadeIn(delay: 0.25)
        }
    }

    // MARK: - Completion Overlay
    private var completionOverlay: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(IslamicColors.primaryGreenFallback)
                .symbolEffect(.bounce)

            Text("Completed!")
                .font(AppTypography.englishTitle)
                .foregroundStyle(.primary)

            Text("May Allah accept your doaa")
                .font(AppTypography.englishBody)
                .foregroundStyle(.secondary)
        }
        .padding(AppSpacing.xl)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.extraLarge)
                .fill(.ultraThinMaterial)
        )
        .transition(.scale.combined(with: .opacity))
    }
}

#Preview {
    DoaaDetailView(
        doaa: DoaaData.morningAzkar[0],
        viewModel: DoaaViewModel()
    )
}
