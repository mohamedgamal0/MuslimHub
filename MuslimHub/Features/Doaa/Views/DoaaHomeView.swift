import SwiftUI

struct DoaaHomeView: View {
    @State private var viewModel = DoaaViewModel()
    @State private var selectedCategory: DoaaCategory?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    headerSection
                    filterSection
                    categoriesGrid
                }
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
            .refreshable {
                viewModel.loadFavorites()
            }
            .background(Color(.systemGroupedBackground))
            .navigationDestination(item: $selectedCategory) { category in
                DoaaCategoryView(category: category, viewModel: viewModel)
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        ZStack(alignment: .bottomLeading) {
            AppGradients.tealWave
                .frame(height: 180)
                .overlay(
                    IslamicPatternView(color: .white.opacity(0.06), lineWidth: 0.5)
                )
                .clipShape(
                    UnevenRoundedRectangle(
                        bottomLeadingRadius: AppCornerRadius.extraLarge,
                        bottomTrailingRadius: AppCornerRadius.extraLarge
                    )
                )

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Image(systemName: "hands.sparkles.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(IslamicColors.goldFallback)

                Text(L10n.dailySupplications)
                    .font(AppTypography.englishTitle)
                    .foregroundStyle(.white)

                Text(L10n.doaa)
                    .font(AppTypography.arabicTitle)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.lg)
        }
        .fadeIn()
    }

    // MARK: - Filter
    private var filterSection: some View {
        HStack {
            Button {
                withAnimation(.spring(response: 0.3)) {
                    viewModel.showFavoritesOnly.toggle()
                }
            } label: {
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: viewModel.showFavoritesOnly ? "heart.fill" : "heart")
                        .foregroundStyle(viewModel.showFavoritesOnly ? .red : .secondary)
                        .symbolEffect(.bounce, value: viewModel.showFavoritesOnly)

                    Text(L10n.favorites)
                        .font(AppTypography.englishCaption)
                        .foregroundStyle(viewModel.showFavoritesOnly ? .primary : .secondary)
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    Capsule()
                        .fill(viewModel.showFavoritesOnly
                              ? Color.red.opacity(0.1)
                              : Color(.secondarySystemBackground))
                )
            }

            Spacer()

            Text("\(viewModel.allDoaas.count) \(LanguageManager.shared.localized("supplications", arabic: "دعاء"))")
                .font(AppTypography.englishSmall)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, AppSpacing.md)
        .slideIn(delay: 0.1, from: .trailing)
    }

    // MARK: - Categories Grid
    private var categoriesGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: AppSpacing.md),
            GridItem(.flexible(), spacing: AppSpacing.md)
        ], spacing: AppSpacing.md) {
            ForEach(Array(viewModel.categories.enumerated()), id: \.element.id) { index, category in
                DoaaCategoryCardView(
                    category: category,
                    count: viewModel.doaaCount(for: category)
                ) {
                    selectedCategory = category
                }
                .slideIn(delay: Double(index) * 0.06, from: .bottom)
            }
        }
        .padding(.horizontal, AppSpacing.md)
    }
}

// MARK: - Category Card
struct DoaaCategoryCardView: View {
    let category: DoaaCategory
    let count: Int
    var action: () -> Void

    private var categoryGradient: LinearGradient {
        switch category {
        case .morning:
            return LinearGradient(colors: [.green, .teal], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .evening:
            return LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .postPrayer:
            return LinearGradient(colors: [.mint, .teal], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .travel:
            return LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .health:
            return LinearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .general:
            return LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .food:
            return LinearGradient(colors: [.orange, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .sleep:
            return LinearGradient(colors: [.indigo, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .protection:
            return LinearGradient(colors: [.gray, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                        .fill(categoryGradient)
                        .frame(width: 56, height: 56)

                    Image(systemName: category.icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                }

                Text(category.nameArabic)
                    .font(.system(size: 16, weight: .bold, design: .serif))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(category.nameEnglish)
                    .font(AppTypography.englishSmall)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

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

#Preview {
    DoaaHomeView()
}
