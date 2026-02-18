import SwiftUI

struct SurahDetailView: View {
    let surahInfo: SurahListItem
    let viewModel: QuranViewModel
    @State private var scrolledAyahId: Int?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 10) {
                    surahHeader

                    if viewModel.isLoadingDetail {
                        loadingSection
                    } else if let error = viewModel.detailError {
                        errorSection(error)
                    } else if let detail = viewModel.currentDetail {
                        bismillah(detail)
                        ayahsList(detail)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .refreshable {
                await viewModel.refreshSurahDetail(number: surahInfo.number)
            }
            .background(Color(.systemGroupedBackground))
            .onChange(of: scrolledAyahId) { _, newValue in
                if let id = newValue {
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(id, anchor: .center)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text(surahInfo.name)
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundStyle(.primary)
                    Text(surahInfo.englishName)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                audioButton
            }
        }
        .overlay(alignment: .bottom) {
            if viewModel.isPlaying && viewModel.currentPlayingSurahId == surahInfo.number {
                audioPlayerBar
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .task {
            await viewModel.fetchSurahDetail(number: surahInfo.number)
        }
    }

    // MARK: - Surah Header
    private var surahHeader: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(AppGradients.islamicGreen)
                .frame(minHeight: 220)
                .overlay(
                    IslamicPatternView(color: .white.opacity(0.08), lineWidth: 0.5)
                        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.large))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.large)
                        .strokeBorder(.white.opacity(0.15), lineWidth: 1)
                )

            VStack(spacing: AppSpacing.md) {
                Text(surahInfo.name)
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text(surahInfo.englishNameTranslation)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.9))

                IslamicDivider(color: .white.opacity(0.35))
                    .frame(width: 220)

                HStack(spacing: AppSpacing.xl) {
                    InfoBadge(
                        label: surahInfo.revelationLabel,
                        value: "\(surahInfo.number)",
                        icon: "number"
                    )
                    .foregroundStyle(.white)

                    InfoBadge(
                        label: L10n.verses,
                        value: "\(surahInfo.numberOfAyahs)",
                        icon: "text.book.closed"
                    )
                    .foregroundStyle(.white)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    Capsule()
                        .fill(.white.opacity(0.12))
                )
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.lg)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.sm)
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
        .fadeIn()
    }

    // MARK: - Bismillah
    @ViewBuilder
    private func bismillah(_ detail: SurahDetail) -> some View {
        if detail.number != 1 && detail.number != 9 {
            Text("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
                .font(AppTypography.arabicBody)
                .foregroundStyle(IslamicColors.primaryGreenFallback)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.lg)
                .fadeIn(delay: 0.1)
        }
    }

    // MARK: - Ayahs List
    private func ayahsList(_ detail: SurahDetail) -> some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(detail.ayahs.enumerated()), id: \.element.id) { index, ayah in
                AyahCardView(
                    ayah: ayah,
                    surahNumber: detail.number,
                    surahName: detail.englishName,
                    viewModel: viewModel,
                    isHighlighted: viewModel.highlightedAyahId == ayah.id,
                    isPlaying: viewModel.currentPlayingAyahNumber == ayah.numberInSurah
                        && viewModel.currentPlayingSurahId == detail.number
                )
                .id(ayah.id)
                .slideIn(delay: min(Double(index) * 0.02, 0.4), from: .bottom)

                if index < detail.ayahs.count - 1 {
                    ayahSeparator
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.bottom, viewModel.isPlaying ? 120 : 100)
    }

    // MARK: - Ayah Separator (gold line + icon between verses)
    private var ayahSeparator: some View {
        HStack(spacing: AppSpacing.sm) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, IslamicColors.goldFallback.opacity(0.6)],
                        startPoint: .leading,
                        endPoint: .center
                    )
                )
                .frame(height: 1)

            Image(systemName: "star.fill")
                .font(.system(size: 8))
                .foregroundStyle(IslamicColors.goldFallback)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [IslamicColors.goldFallback.opacity(0.6), Color.clear],
                        startPoint: .center,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
        }
        .padding(.vertical, AppSpacing.md)
    }

    // MARK: - Loading
    private var loadingSection: some View {
        VStack(spacing: AppSpacing.md) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(IslamicColors.primaryGreenFallback)
            Text(L10n.loading)
                .font(AppTypography.englishBody)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }

    // MARK: - Error
    private func errorSection(_ message: String) -> some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)

            Text(message)
                .font(AppTypography.englishBody)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button {
                Task { await viewModel.refreshSurahDetail(number: surahInfo.number) }
            } label: {
                Text(L10n.retry)
                    .font(AppTypography.englishSubtitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.vertical, AppSpacing.sm)
                    .background(Capsule().fill(AppGradients.islamicGreen))
            }
            .buttonStyle(BounceButtonStyle())
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
        .padding(.horizontal, AppSpacing.lg)
    }

    // MARK: - Audio Button
    private var audioButton: some View {
        Button {
            if viewModel.isPlaying && viewModel.currentPlayingSurahId == surahInfo.number {
                viewModel.togglePlayPause()
            } else {
                viewModel.playFirstAyah(surahId: surahInfo.number)
            }
        } label: {
            Image(systemName: viewModel.isPlaying && viewModel.currentPlayingSurahId == surahInfo.number
                  ? "pause.circle.fill" : "play.circle.fill")
                .font(.system(size: 24))
                .foregroundStyle(IslamicColors.primaryGreenFallback)
                .symbolEffect(.bounce, value: viewModel.isPlaying)
        }
    }

    // MARK: - Audio Player Bar
    private var audioPlayerBar: some View {
        VStack(spacing: 0) {
            ProgressView(value: viewModel.playbackProgress)
                .tint(IslamicColors.primaryGreenFallback)

            HStack {
                VStack(alignment: .leading) {
                    Text(surahInfo.englishName)
                        .font(AppTypography.englishSubtitle)
                    if let ayahNum = viewModel.currentPlayingAyahNumber {
                        Text("\(L10n.ayah) \(ayahNum)")
                            .font(AppTypography.englishCaption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                HStack(spacing: AppSpacing.md) {
                    Button {
                        viewModel.togglePlayPause()
                    } label: {
                        Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(IslamicColors.primaryGreenFallback)
                    }

                    Button {
                        viewModel.stopAudio()
                    } label: {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
        }
        .background(.ultraThinMaterial)
    }
}

// MARK: - Ayah Card
struct AyahCardView: View {
    let ayah: AyahDetail
    let surahNumber: Int
    let surahName: String
    let viewModel: QuranViewModel
    let isHighlighted: Bool
    let isPlaying: Bool

    @State private var showTranslation = true

    var body: some View {
        VStack(alignment: .trailing, spacing: AppSpacing.md) {
            HStack {
                ayahNumberBadge
                Spacer()
                actionButtons
            }

            Text(ayah.textArabic)
                .font(AppTypography.arabicAyah)
                .multilineTextAlignment(.trailing)
                .lineSpacing(12)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundStyle(isPlaying ? IslamicColors.primaryGreenFallback : .primary)

            if showTranslation {
                IslamicDivider(color: Color.gray.opacity(0.2))

                Text(ayah.textEnglish)
                    .font(AppTypography.englishBody)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(isHighlighted
                      ? IslamicColors.goldFallback.opacity(0.1)
                      : Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .stroke(
                    isPlaying ? IslamicColors.primaryGreenFallback.opacity(0.5) : Color.clear,
                    lineWidth: 2
                )
        )
        .islamicShadow()
        .animation(.easeInOut(duration: 0.3), value: isHighlighted)
        .animation(.easeInOut(duration: 0.3), value: isPlaying)
    }

    private var ayahNumberBadge: some View {
        ZStack {
            Circle()
                .fill(IslamicColors.primaryGreenFallback.opacity(0.1))
                .frame(width: 36, height: 36)

            Text("\(ayah.numberInSurah)")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(IslamicColors.primaryGreenFallback)
        }
    }

    private var actionButtons: some View {
        HStack(spacing: AppSpacing.sm) {
            Button {
                viewModel.playAyah(surahId: surahNumber, ayah: ayah)
            } label: {
                Image(systemName: isPlaying ? "speaker.wave.2.fill" : "play.circle")
                    .font(.system(size: 18))
                    .foregroundStyle(isPlaying ? IslamicColors.primaryGreenFallback : .secondary)
                    .symbolEffect(.variableColor.iterative, isActive: isPlaying)
            }

            Button {
                viewModel.toggleBookmark(surahNumber: surahNumber, surahName: surahName, ayah: ayah)
            } label: {
                Image(systemName: viewModel.isBookmarked(surahId: surahNumber, ayahNumber: ayah.numberInSurah)
                      ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 18))
                    .foregroundStyle(viewModel.isBookmarked(surahId: surahNumber, ayahNumber: ayah.numberInSurah)
                                    ? IslamicColors.goldFallback : .secondary)
                    .symbolEffect(.bounce, value: viewModel.isBookmarked(surahId: surahNumber, ayahNumber: ayah.numberInSurah))
            }

            Button {
                withAnimation { showTranslation.toggle() }
            } label: {
                Image(systemName: showTranslation ? "text.book.closed.fill" : "text.book.closed")
                    .font(.system(size: 18))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SurahDetailView(
            surahInfo: SurahListItem(
                number: 1,
                name: "سُورَةُ ٱلْفَاتِحَةِ",
                englishName: "Al-Faatiha",
                englishNameTranslation: "The Opening",
                numberOfAyahs: 7,
                revelationType: "Meccan"
            ),
            viewModel: QuranViewModel()
        )
    }
}
