import SwiftUI

struct HadithHomeView: View {
    @State private var viewModel = HadithViewModel()
    @State private var selectedCollection: HadithCollection?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    headerSection
                    collectionsSection
                }
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationDestination(item: $selectedCollection) { collection in
                HadithCollectionView(collection: collection, viewModel: viewModel)
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color(red: 0.15, green: 0.25, blue: 0.45), Color(red: 0.1, green: 0.15, blue: 0.35)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 180)
            .overlay(
                IslamicPatternView(color: .white.opacity(0.05), lineWidth: 0.5)
            )
            .clipShape(
                UnevenRoundedRectangle(
                    bottomLeadingRadius: AppCornerRadius.extraLarge,
                    bottomTrailingRadius: AppCornerRadius.extraLarge
                )
            )

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(IslamicColors.goldFallback)

                Text(L10n.hadithCollections)
                    .font(AppTypography.englishTitle)
                    .foregroundStyle(.white)

                Text(L10n.hadith)
                    .font(AppTypography.arabicTitle)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.lg)
        }
        .fadeIn()
    }

    // MARK: - Collections
    private var collectionsSection: some View {
        LazyVStack(spacing: AppSpacing.md) {
            ForEach(Array(viewModel.collections.enumerated()), id: \.element.id) { index, collection in
                HadithCollectionCard(collection: collection) {
                    selectedCollection = collection
                }
                .slideIn(delay: Double(index) * 0.06, from: .bottom)
            }
        }
        .padding(.horizontal, AppSpacing.md)
    }
}

// MARK: - Collection Card
struct HadithCollectionCard: View {
    let collection: HadithCollection
    var action: () -> Void

    private var cardGradient: LinearGradient {
        switch collection.id {
        case "bukhari":
            return LinearGradient(colors: [.green.opacity(0.9), .teal.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "muslim":
            return LinearGradient(colors: [.blue.opacity(0.9), .indigo.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "abudawud":
            return LinearGradient(colors: [.purple.opacity(0.9), .pink.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "tirmidhi":
            return LinearGradient(colors: [.orange.opacity(0.9), .red.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "nasai":
            return LinearGradient(colors: [.cyan.opacity(0.9), .blue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            return LinearGradient(colors: [.teal.opacity(0.9), .green.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                        .fill(cardGradient)
                        .frame(width: 56, height: 56)

                    Image(systemName: collection.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(collection.arabicName)
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundStyle(.primary)

                    Text(collection.name)
                        .font(AppTypography.englishBody)
                        .foregroundStyle(.primary.opacity(0.8))

                    Text(collection.localizedDescription)
                        .font(AppTypography.englishSmall)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
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
            .islamicShadow()
        }
        .buttonStyle(SpringButtonStyle())
    }
}

#Preview {
    HadithHomeView()
}
