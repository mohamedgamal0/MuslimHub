import SwiftUI

struct HadithSectionDetailView: View {
    let collection: HadithCollection
    let section: HadithSection
    @Bindable var viewModel: HadithViewModel

    var body: some View {
        Group {
            if viewModel.isLoadingHadiths && viewModel.hadiths.isEmpty {
                loadingView
            } else if let error = viewModel.hadithsError, viewModel.hadiths.isEmpty {
                errorView(error)
            } else {
                hadithsList
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(section.name)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.searchText, prompt: L10n.searchHadith)
        .task {
            viewModel.clearHadiths()
            await viewModel.fetchHadiths(collection: collection, section: section)
        }
    }

    // MARK: - Hadiths List
    private var hadithsList: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                if !viewModel.filteredHadiths.isEmpty {
                    Text("\(viewModel.filteredHadiths.count) \(L10n.hadithNumber)")
                        .font(AppTypography.englishSmall)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, AppSpacing.md)
                }

                ForEach(Array(viewModel.filteredHadiths.enumerated()), id: \.element.id) { index, hadith in
                    HadithCardView(hadith: hadith)
                        .slideIn(delay: min(Double(index) * 0.02, 0.3), from: .bottom)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.md)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
        .refreshable {
            await viewModel.refreshHadiths(collection: collection, section: section)
        }
    }

    // MARK: - Loading
    private var loadingView: some View {
        VStack(spacing: AppSpacing.md) {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
                .tint(IslamicColors.primaryGreenFallback)
            Text(L10n.loading)
                .font(AppTypography.englishBody)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Error
    private func errorView(_ message: String) -> some View {
        VStack(spacing: AppSpacing.md) {
            Spacer()
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text(message)
                .font(AppTypography.englishBody)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.lg)

            Button {
                Task { await viewModel.refreshHadiths(collection: collection, section: section) }
            } label: {
                Text(L10n.retry)
                    .font(AppTypography.englishSubtitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.vertical, AppSpacing.sm)
                    .background(Capsule().fill(AppGradients.islamicGreen))
            }
            .buttonStyle(BounceButtonStyle())
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Hadith Card
struct HadithCardView: View {
    let hadith: HadithItem
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                ZStack {
                    Circle()
                        .fill(IslamicColors.primaryGreenFallback.opacity(0.1))
                        .frame(width: 36, height: 36)

                    Text("#\(hadith.number)")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(IslamicColors.primaryGreenFallback)
                }

                if let grade = hadith.grade {
                    Text(grade)
                        .font(AppTypography.englishSmall)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule().fill(gradeColor(grade))
                        )
                }

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.3)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }

            if let arabicText = hadith.arabicText, !arabicText.isEmpty {
                Text(arabicText)
                    .font(AppTypography.arabicBody)
                    .multilineTextAlignment(.trailing)
                    .lineSpacing(8)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundStyle(.primary)

                IslamicDivider(color: Color.gray.opacity(0.15))
            }

            Text(hadith.text)
                .font(AppTypography.englishBody)
                .foregroundStyle(hadith.arabicText == nil ? .primary : .secondary)
                .lineSpacing(4)
                .lineLimit(isExpanded ? nil : 5)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let bookNum = hadith.bookNumber {
                HStack(spacing: 4) {
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 10))
                    Text("\(hadith.collectionName) - Book \(bookNum), Hadith \(hadith.number)")
                        .font(AppTypography.englishSmall)
                }
                .foregroundStyle(.tertiary)
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.large)
                .fill(Color(.systemBackground))
        )
        .islamicShadow()
    }

    private func gradeColor(_ grade: String) -> Color {
        let lowered = grade.lowercased()
        if lowered.contains("sahih") { return .green.opacity(0.8) }
        if lowered.contains("hasan") { return .blue.opacity(0.8) }
        if lowered.contains("daif") || lowered.contains("weak") { return .orange.opacity(0.8) }
        return .gray.opacity(0.6)
    }
}

#Preview {
    NavigationStack {
        HadithSectionDetailView(
            collection: HadithCollection.allCollections[0],
            section: HadithSection(id: "1", number: 1, name: "Revelation", arabicName: "الوحي"),
            viewModel: HadithViewModel()
        )
    }
}
