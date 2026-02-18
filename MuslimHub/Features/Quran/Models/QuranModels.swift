import Foundation

// MARK: - API Response Wrappers
struct QuranListResponse: Codable {
    let code: Int
    let status: String
    let data: [SurahListItem]
}

struct QuranEditionsResponse: Codable {
    let code: Int
    let status: String
    let data: [SurahEditionData]
}

// MARK: - Surah List Item (from /surah endpoint)
struct SurahListItem: Identifiable, Codable, Hashable {
    var id: Int { number }
    let number: Int
    let name: String
    let englishName: String
    let englishNameTranslation: String
    let numberOfAyahs: Int
    let revelationType: String

    var localizedName: String {
        LanguageManager.shared.currentLanguage == .arabic ? name : englishName
    }

    var revelationLabel: String {
        revelationType == "Meccan"
            ? LanguageManager.shared.localized("Meccan", arabic: "مكية")
            : LanguageManager.shared.localized("Medinan", arabic: "مدنية")
    }
}

// MARK: - Surah Edition Data (from /surah/{id}/editions endpoint)
struct SurahEditionData: Codable {
    let number: Int
    let name: String
    let englishName: String
    let englishNameTranslation: String
    let numberOfAyahs: Int
    let revelationType: String
    let ayahs: [AyahAPIData]
    let edition: EditionInfo
}

struct AyahAPIData: Codable {
    let number: Int
    let text: String
    let numberInSurah: Int
    let juz: Int
    let page: Int
    let hizbQuarter: Int?
}

struct EditionInfo: Codable {
    let identifier: String
    let language: String
    let name: String
    let englishName: String
}

// MARK: - Merged Ayah (Arabic + English combined)
struct AyahDetail: Identifiable, Hashable {
    let id: Int
    let globalNumber: Int
    let numberInSurah: Int
    let textArabic: String
    let textEnglish: String
    let juz: Int
    let page: Int
}

// MARK: - Surah Detail (fully loaded with ayahs)
struct SurahDetail {
    let number: Int
    let name: String
    let englishName: String
    let englishNameTranslation: String
    let revelationType: String
    let numberOfAyahs: Int
    let ayahs: [AyahDetail]

    var revelationLabel: String {
        revelationType == "Meccan"
            ? LanguageManager.shared.localized("Meccan", arabic: "مكية")
            : LanguageManager.shared.localized("Medinan", arabic: "مدنية")
    }
}

// MARK: - Bookmark
struct QuranBookmark: Identifiable, Codable, Hashable {
    let id: UUID
    let surahId: Int
    let surahName: String
    let ayahNumber: Int
    let ayahText: String
    let dateAdded: Date

    init(surahId: Int, surahName: String, ayahNumber: Int, ayahText: String) {
        self.id = UUID()
        self.surahId = surahId
        self.surahName = surahName
        self.ayahNumber = ayahNumber
        self.ayahText = ayahText
        self.dateAdded = Date()
    }
}
