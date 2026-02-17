import SwiftUI

struct DoaaCategoryView: View {
    let category: DoaaCategory
    let viewModel: DoaaViewModel
    @State private var selectedDoaa: Doaa?

    private var doaas: [Doaa] {
        viewModel.allDoaas.filter { $0.category == category }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(Array(doaas.enumerated()), id: \.element.id) { index, doaa in
                    DoaaCardView(doaa: doaa, viewModel: viewModel) {
                        selectedDoaa = doaa
                    }
                    .slideIn(delay: Double(index) * 0.05, from: .bottom)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.md)
            .padding(.bottom, 80)
        }
        .scrollIndicators(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle(category.localizedName)
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedDoaa) { doaa in
            DoaaDetailView(doaa: doaa, viewModel: viewModel)
        }
    }
}

// MARK: - Doaa Card View
struct DoaaCardView: View {
    let doaa: Doaa
    let viewModel: DoaaViewModel
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .trailing, spacing: AppSpacing.md) {
                HStack {
                    favoriteButton
                    Spacer()
                    repeatBadge
                }

                Text(doaa.textArabic)
                    .font(AppTypography.arabicBody)
                    .multilineTextAlignment(.trailing)
                    .lineSpacing(10)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundStyle(.primary)

                IslamicDivider(color: Color.gray.opacity(0.15))

                Text(doaa.textEnglish)
                    .font(AppTypography.englishBody)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(3)

                if !doaa.source.isEmpty {
                    HStack {
                        Image(systemName: "book.closed.fill")
                            .font(.system(size: 10))
                        Text(doaa.source)
                            .font(AppTypography.englishSmall)
                    }
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
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

    private var favoriteButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                viewModel.toggleFavorite(doaa)
            }
        } label: {
            Image(systemName: doaa.isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 20))
                .foregroundStyle(doaa.isFavorite ? .red : .secondary)
                .symbolEffect(.bounce, value: doaa.isFavorite)
        }
    }

    private var repeatBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "repeat")
                .font(.system(size: 10))
            Text("\(doaa.repeatCount)")
                .font(AppTypography.englishSmall)
        }
        .foregroundStyle(IslamicColors.primaryGreenFallback)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(IslamicColors.primaryGreenFallback.opacity(0.1))
        )
    }
}

#Preview {
    NavigationStack {
        DoaaCategoryView(
            category: .morning,
            viewModel: DoaaViewModel()
        )
    }
}
