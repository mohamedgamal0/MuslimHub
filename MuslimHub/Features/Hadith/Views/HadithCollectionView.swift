import SwiftUI

struct HadithCollectionView: View {
    let collection: HadithCollection
    let viewModel: HadithViewModel
    @State private var selectedSection: HadithSection?

    var body: some View {
        Group {
            if viewModel.isLoadingSections && viewModel.sections.isEmpty {
                loadingView
            } else if let error = viewModel.sectionsError, viewModel.sections.isEmpty {
                errorView(error)
            } else {
                sectionsList
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(collection.localizedName)
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(item: $selectedSection) { section in
            HadithSectionDetailView(
                collection: collection,
                section: section,
                viewModel: viewModel
            )
        }
        .task {
            await viewModel.fetchSections(for: collection)
        }
    }

    // MARK: - Sections List
    private var sectionsList: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.sm) {
                ForEach(Array(viewModel.sections.enumerated()), id: \.element.id) { index, section in
                    Button {
                        selectedSection = section
                    } label: {
                        HStack(spacing: AppSpacing.md) {
                            ZStack {
                                Circle()
                                    .fill(IslamicColors.primaryGreenFallback.opacity(0.1))
                                    .frame(width: 40, height: 40)

                                Text("\(section.number)")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundStyle(IslamicColors.primaryGreenFallback)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(section.name)
                                    .font(AppTypography.englishSubtitle)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)

                                if let arabicName = section.arabicName, !arabicName.isEmpty {
                                    Text(arabicName)
                                        .font(.system(size: 14, design: .serif))
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.tertiary)
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
                    .slideIn(delay: min(Double(index) * 0.02, 0.4), from: .bottom)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.md)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
        .refreshable {
            await viewModel.refreshSections(for: collection)
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
                Task { await viewModel.refreshSections(for: collection) }
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

#Preview {
    NavigationStack {
        HadithCollectionView(
            collection: HadithCollection.allCollections[0],
            viewModel: HadithViewModel()
        )
    }
}
