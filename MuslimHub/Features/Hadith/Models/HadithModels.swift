import Foundation

// MARK: - Hadith Collection (static catalog)
struct HadithCollection: Identifiable, Hashable {
    let id: String
    let name: String
    let arabicName: String
    let editionKey: String
    /// hadithapi.com book slug (e.g. sahih-bukhari)
    let bookSlugHadithAPI: String?
    let icon: String
    let description: String
    let descriptionArabic: String

    var localizedName: String {
        LanguageManager.shared.currentLanguage == .arabic ? arabicName : name
    }

    var localizedDescription: String {
        LanguageManager.shared.currentLanguage == .arabic ? descriptionArabic : description
    }
}

extension HadithCollection {
    static let allCollections: [HadithCollection] = [
        HadithCollection(
            id: "bukhari", name: "Sahih al-Bukhari", arabicName: "صحيح البخاري",
            editionKey: "eng-bukhari", bookSlugHadithAPI: "sahih-bukhari",
            icon: "book.closed.fill",
            description: "The most authentic collection of Hadith",
            descriptionArabic: "أصح كتب الحديث"
        ),
        HadithCollection(
            id: "muslim", name: "Sahih Muslim", arabicName: "صحيح مسلم",
            editionKey: "eng-muslim", bookSlugHadithAPI: "sahih-muslim",
            icon: "book.closed.fill",
            description: "The second most authentic Hadith collection",
            descriptionArabic: "ثاني أصح كتب الحديث"
        ),
        HadithCollection(
            id: "abudawud", name: "Sunan Abu Dawud", arabicName: "سنن أبي داود",
            editionKey: "eng-abudawud", bookSlugHadithAPI: "abu-dawood",
            icon: "text.book.closed.fill",
            description: "One of the six major Hadith collections",
            descriptionArabic: "أحد الكتب الستة"
        ),
        HadithCollection(
            id: "tirmidhi", name: "Jami at-Tirmidhi", arabicName: "جامع الترمذي",
            editionKey: "eng-tirmidhi", bookSlugHadithAPI: "al-tirmidhi",
            icon: "text.book.closed.fill",
            description: "Collection by Imam at-Tirmidhi",
            descriptionArabic: "جمع الإمام الترمذي"
        ),
        HadithCollection(
            id: "nasai", name: "Sunan an-Nasa'i", arabicName: "سنن النسائي",
            editionKey: "eng-nasai", bookSlugHadithAPI: "sunan-nasai",
            icon: "text.book.closed.fill",
            description: "Collection by Imam an-Nasa'i",
            descriptionArabic: "جمع الإمام النسائي"
        ),
        HadithCollection(
            id: "ibnmajah", name: "Sunan Ibn Majah", arabicName: "سنن ابن ماجه",
            editionKey: "eng-ibnmajah", bookSlugHadithAPI: "ibn-e-majah",
            icon: "text.book.closed.fill",
            description: "Collection by Imam Ibn Majah",
            descriptionArabic: "جمع الإمام ابن ماجه"
        ),
    ]
}

// MARK: - hadithapi.com API responses
struct HadithAPIComChaptersResponse: Codable {
    let data: [HadithAPIComChapter]?
    let chapters: [HadithAPIComChapter]?
    var list: [HadithAPIComChapter] { (data ?? chapters) ?? [] }
}

struct HadithAPIComChapter: Codable {
    let id: Int?
    let chapterNumber: StringOrInt?
    let chapter_number: StringOrInt?
    let title: String?
    let chapterEnglish: String?
    let chapterArabic: String?
    let bookSlug: String?
    let book_slug: String?
    var sectionNumber: Int {
        let n = chapterNumber ?? chapter_number
        return n?.intValue ?? id ?? 0
    }
    var sectionName: String { chapterEnglish ?? title ?? "Chapter \(sectionNumber)" }
}

// Top-level hadiths response: { "status": 200, "message": "...", "hadiths": { "data": [...] } }
struct HadithAPIComHadithsResponse: Codable {
    let status: Int?
    let message: String?
    let hadiths: HadithAPIComHadithsPayload?
    var list: [HadithAPIComHadith] { hadiths?.data ?? [] }
}

// Paginated payload: hadiths.data is the array of hadiths
struct HadithAPIComHadithsPayload: Codable {
    let data: [HadithAPIComHadith]?
    let current_page: Int?
    let last_page: Int?
    let per_page: Int?
}

struct HadithAPIComHadith: Codable {
    let id: Int?
    let hadithNumber: StringOrInt?
    let hadith_number: StringOrInt?
    let hadithEnglish: String?
    let hadith_english: String?
    let hadithArabic: String?
    let hadith_arabic: String?
    let englishNarrator: String?
    let chapterId: StringOrInt?
    let chapterNumber: StringOrInt?
    let chapter_number: StringOrInt?
    let status: String?
    var number: Int {
        let n = hadithNumber ?? hadith_number
        return n?.intValue ?? id ?? 0
    }
    var englishText: String? { hadithEnglish ?? hadith_english }
    var arabicText: String? { hadithArabic ?? hadith_arabic }
}

// API sometimes returns numbers as "1" (string) or 1 (int)
struct StringOrInt: Codable {
    let intValue: Int?
    let stringValue: String?
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let i = try? container.decode(Int.self) {
            intValue = i
            stringValue = "\(i)"
        } else if let s = try? container.decode(String.self) {
            stringValue = s
            intValue = Int(s)
        } else {
            intValue = nil
            stringValue = nil
        }
    }
}

// MARK: - API Response Models (fawazahmed0 CDN)
struct HadithEditionResponse: Codable {
    let metadata: HadithMetadata
    let hadiths: [HadithAPIData]
}

struct HadithMetadata: Codable {
    let name: String
    let shortName: String?
    let language: String?
    let sections: [String: String]?
    let section_details: [String: HadithSectionDetail]?

    enum CodingKeys: String, CodingKey {
        case name, shortName, language, sections
        case section_details
    }
}

struct HadithSectionDetail: Codable {
    let hadithnumber_first: Int?
    let hadithnumber_last: Int?
    let arabicname: String?

    enum CodingKeys: String, CodingKey {
        case hadithnumber_first
        case hadithnumber_last
        case arabicname
    }
}

struct HadithAPIData: Codable {
    let hadithnumber: Int
    let text: String
    let grades: [HadithGrade]?
    let reference: HadithReference?
}

struct HadithGrade: Codable {
    let name: String?
    let grade: String?
}

struct HadithReference: Codable {
    let book: Int?
    let hadith: Int?
}

// MARK: - App-level Hadith Item
struct HadithItem: Identifiable, Hashable {
    let id: Int
    let number: Int
    let text: String
    let arabicText: String?
    let bookNumber: Int?
    let grade: String?
    let collectionName: String

    static func == (lhs: HadithItem, rhs: HadithItem) -> Bool {
        lhs.id == rhs.id && lhs.collectionName == rhs.collectionName
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(collectionName)
    }
}

// MARK: - Section
struct HadithSection: Identifiable, Hashable {
    let id: String
    let number: Int
    let name: String
    let arabicName: String?
}
