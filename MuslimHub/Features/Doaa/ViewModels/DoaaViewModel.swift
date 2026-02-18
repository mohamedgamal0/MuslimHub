import SwiftUI

@Observable
final class DoaaViewModel {
    // MARK: - Properties
    var allDoaas: [Doaa] = []
    var selectedCategory: DoaaCategory?
    var searchText = ""

    init() {
        allDoaas = AdhkarLoader.loadFromBundle()
    }

    // MARK: - Computed
    var categories: [DoaaCategory] {
        DoaaCategory.allCases
    }

    var filteredDoaas: [Doaa] {
        var result = allDoaas

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
    func selectCategory(_ category: DoaaCategory?) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            selectedCategory = category
        }
    }
}
