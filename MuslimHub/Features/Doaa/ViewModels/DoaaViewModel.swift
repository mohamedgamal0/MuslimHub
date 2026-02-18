import SwiftUI

@Observable
final class DoaaViewModel {
    // MARK: - Properties
    var allDoaas: [Doaa] = []
    var selectedCategory: DoaaCategory?
    var searchText = ""
    var showFavoritesOnly = false

    init() {
        allDoaas = AdhkarLoader.loadFromBundle()
        loadFavorites()
    }

    // MARK: - Computed
    var categories: [DoaaCategory] {
        DoaaCategory.allCases
    }

    var filteredDoaas: [Doaa] {
        var result = allDoaas

        if showFavoritesOnly {
            result = result.filter { $0.isFavorite }
        }

        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            result = result.filter { doaa in
                doaa.textEnglish.localizedCaseInsensitiveContains(searchText) ||
                doaa.textArabic.localizedCaseInsensitiveContains(searchText) ||
                doaa.transliteration.localizedCaseInsensitiveContains(searchText)
            }
        }

        return result
    }

    var doaasForCategory: [DoaaCategory: [Doaa]] {
        Dictionary(grouping: allDoaas, by: \.category)
    }

    func doaaCount(for category: DoaaCategory) -> Int {
        allDoaas.filter { $0.category == category }.count
    }

    // MARK: - Actions
    func toggleFavorite(_ doaa: Doaa) {
        if let index = allDoaas.firstIndex(where: { $0.id == doaa.id }) {
            allDoaas[index].isFavorite.toggle()
            saveFavorites()
        }
    }

    func selectCategory(_ category: DoaaCategory?) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            selectedCategory = category
        }
    }

    // MARK: - Persistence
    private func saveFavorites() {
        let favoriteIds = allDoaas.filter(\.isFavorite).map(\.id.uuidString)
        UserDefaults.standard.set(favoriteIds, forKey: "doaa_favorites")
    }

    func loadFavorites() {
        guard let savedIds = UserDefaults.standard.stringArray(forKey: "doaa_favorites") else { return }
        for i in allDoaas.indices {
            allDoaas[i].isFavorite = savedIds.contains(allDoaas[i].id.uuidString)
        }
    }
}
