import SwiftUI

@Observable
final class HadithViewModel {
    // MARK: - Properties
    var collections = HadithCollection.allCollections
    var sections: [HadithSection] = []
    var hadiths: [HadithItem] = []
    var searchText = ""

    var isLoadingSections = false
    var isLoadingHadiths = false
    var sectionsError: String?
    var hadithsError: String?

    var selectedCollection: HadithCollection?
    var selectedSection: HadithSection?

    private let network = NetworkService.shared
    private var sectionsCache: [String: [HadithSection]] = [:]
    private var hadithsCache: [String: [HadithItem]] = [:]

    // MARK: - Computed
    var filteredHadiths: [HadithItem] {
        guard !searchText.isEmpty else { return hadiths }
        return hadiths.filter { hadith in
            hadith.text.localizedCaseInsensitiveContains(searchText) ||
            String(hadith.number).contains(searchText)
        }
    }

    // MARK: - Fetch Sections for a Collection
    func fetchSections(for collection: HadithCollection) async {
        let cacheKey = collection.editionKey

        if let cached = sectionsCache[cacheKey] {
            sections = cached
            return
        }

        isLoadingSections = true
        sectionsError = nil

        do {
            let url = HadithAPI.editionInfo(name: collection.editionKey)
            let response = try await network.fetch(HadithEditionResponse.self, from: url)

            guard let sectionsMap = response.metadata.sections else {
                sectionsError = "No sections found"
                isLoadingSections = false
                return
            }

            let sectionDetails = response.metadata.section_details

            let parsed: [HadithSection] = sectionsMap.compactMap { key, value in
                guard let num = Int(key) else { return nil }
                return HadithSection(
                    id: "\(collection.id)_\(key)",
                    number: num,
                    name: value,
                    arabicName: sectionDetails?[key]?.arabicname
                )
            }
            .sorted { $0.number < $1.number }

            sectionsCache[cacheKey] = parsed
            sections = parsed
        } catch {
            sectionsError = error.localizedDescription
        }

        isLoadingSections = false
    }

    func refreshSections(for collection: HadithCollection) async {
        sectionsCache.removeValue(forKey: collection.editionKey)
        await fetchSections(for: collection)
    }

    // MARK: - Fetch Hadiths for a Section
    func fetchHadiths(collection: HadithCollection, section: HadithSection) async {
        let cacheKey = "\(collection.editionKey)_\(section.number)"

        if let cached = hadithsCache[cacheKey] {
            hadiths = cached
            return
        }

        isLoadingHadiths = true
        hadithsError = nil

        do {
            let url = HadithAPI.editionSection(name: collection.editionKey, section: section.number)
            let response = try await network.fetch(HadithEditionResponse.self, from: url)

            let items: [HadithItem] = response.hadiths.map { hadithData in
                let gradeText = hadithData.grades?.first(where: { $0.grade != nil })?.grade

                return HadithItem(
                    id: hadithData.hadithnumber,
                    number: hadithData.hadithnumber,
                    text: hadithData.text,
                    arabicText: nil,
                    bookNumber: hadithData.reference?.book,
                    grade: gradeText,
                    collectionName: collection.name
                )
            }

            hadithsCache[cacheKey] = items
            hadiths = items
        } catch {
            hadithsError = error.localizedDescription
        }

        isLoadingHadiths = false
    }

    func refreshHadiths(collection: HadithCollection, section: HadithSection) async {
        let cacheKey = "\(collection.editionKey)_\(section.number)"
        hadithsCache.removeValue(forKey: cacheKey)
        await fetchHadiths(collection: collection, section: section)
    }

    // MARK: - Reset
    func clearSections() {
        sections = []
        sectionsError = nil
    }

    func clearHadiths() {
        hadiths = []
        searchText = ""
        hadithsError = nil
    }
}
