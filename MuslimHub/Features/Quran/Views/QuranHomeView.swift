import SwiftUI

struct QuranHomeView: View {
    @State private var viewModel = QuranViewModel()
    @State private var selectedSurah: SurahListItem?
    @State private var showBookmarks = false

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 0) {
                        headerSection

                        if viewModel.isLoadingSurahs && viewModel.surahs.isEmpty {
                            loadingView
                        } else if let error = viewModel.surahsError, viewModel.surahs.isEmpty {
                            errorView(error)
                        } else {
                            searchBar
                            surahListSection
                        }
                    }
                    .padding(.top, -geo.safeAreaInsets.top)
                }
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.immediately)
                .refreshable {
                    await viewModel.refreshSurahs()
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationDestination(item: $selectedSurah) { surah in
                SurahDetailView(surahInfo: surah, viewModel: viewModel)
            }
            .sheet(isPresented: $showBookmarks) {
                BookmarksSheet(viewModel: viewModel, selectedSurah: $selectedSurah)
            }
            .task {
                await viewModel.fetchSurahs()
            }
        }
    }

    // MARK: - Header (starts at status bar, bookmark inside header)
    private var headerSection: some View {
        ZStack(alignment: .topLeading) {
            AppGradients.islamicGreen
                .overlay(
                    IslamicPatternView(color: .white.opacity(0.04), lineWidth: 0.4)
                )
                .clipShape(
                    UnevenRoundedRectangle(
                        bottomLeadingRadius: AppCornerRadius.extraLarge,
                        bottomTrailingRadius: AppCornerRadius.extraLarge
                    )
                )

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    CrescentMoonView(size: 26, color: IslamicColors.goldFallback)
                    Spacer()
                    Button {
                        showBookmarks = true
                    } label: {
                        Image(systemName: "bookmark.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(IslamicColors.goldFallback)
                    }
                }

                Text("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
                    .font(.system(size: 15, weight: .regular, design: .serif))
                    .foregroundStyle(.white.opacity(0.95))

                Text(L10n.quran)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, 56)
            .padding(.bottom, AppSpacing.xl)
        }
        .frame(minHeight: 220)
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(edges: .top)
        .fadeIn()
    }

    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(L10n.searchQuran, text: $viewModel.searchText)
                .font(AppTypography.englishBody)
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .fill(Color(.systemBackground))
        )
        .islamicShadow()
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, -AppSpacing.md)
        .fadeIn(delay: 0.1)
    }

    // MARK: - Surah List
    private var surahListSection: some View {
        LazyVStack(spacing: AppSpacing.sm) {
            ForEach(Array(viewModel.filteredSurahs.enumerated()), id: \.element.id) { index, surah in
                SurahRowView(surah: surah) {
                    selectedSurah = surah
                }
                .slideIn(delay: min(Double(index) * 0.02, 0.5), from: .bottom)
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.lg)
        .padding(.bottom, 100)
    }

    // MARK: - Loading
    private var loadingView: some View {
        VStack(spacing: AppSpacing.md) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(IslamicColors.primaryGreenFallback)

            Text(L10n.loading)
                .font(AppTypography.englishBody)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }

    // MARK: - Error
    private func errorView(_ message: String) -> some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            Text(message)
                .font(AppTypography.englishBody)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button {
                Task { await viewModel.refreshSurahs() }
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
        .padding(.top, 80)
        .padding(.horizontal, AppSpacing.lg)
    }
}

// MARK: - Surah Row
struct SurahRowView: View {
    let surah: SurahListItem
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .center, spacing: AppSpacing.md) {
                ZStack {
                    Image(systemName: "diamond.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(IslamicColors.primaryGreenFallback.opacity(0.12))

                    Text("\(surah.number)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(IslamicColors.primaryGreenFallback)
                }
                .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 2) {
                    Text(surah.englishName)
                        .font(AppTypography.englishBody)
                        .foregroundStyle(.primary)

                    HStack(spacing: AppSpacing.xs) {
                        Text(surah.revelationLabel)
                            .font(AppTypography.englishSmall)
                            .foregroundStyle(.secondary)

                        Circle()
                            .fill(Color.secondary.opacity(0.3))
                            .frame(width: 3, height: 3)

                        Text("\(surah.numberOfAyahs) \(L10n.verses)")
                            .font(AppTypography.englishSmall)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(minHeight: 44, alignment: .leading)

                Spacer(minLength: 0)

                Text(surah.name)
                    .font(AppTypography.arabicBody)
                    .foregroundStyle(IslamicColors.primaryGreenFallback)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm + 2)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(Color(.systemBackground))
            )
            .islamicShadow(AppShadow.light)
        }
        .buttonStyle(SpringButtonStyle())
    }
}

// MARK: - Bookmarks Sheet
struct BookmarksSheet: View {
    let viewModel: QuranViewModel
    @Binding var selectedSurah: SurahListItem?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.bookmarks.isEmpty {
                    ContentUnavailableView(
                        L10n.bookmarks,
                        systemImage: "bookmark",
                        description: Text("No bookmarks yet. Tap the bookmark icon on any ayah to save it.")
                    )
                } else {
                    List(viewModel.bookmarks) { bookmark in
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text("\(bookmark.surahName) - \(L10n.ayah) \(bookmark.ayahNumber)")
                                .font(AppTypography.englishSubtitle)

                            Text(bookmark.ayahText)
                                .font(AppTypography.arabicBody)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, AppSpacing.xs)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationTitle(L10n.bookmarks)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    QuranHomeView()
}
