import Foundation

// MARK: - Hadith Collection (static catalog)
struct HadithCollection: Identifiable, Hashable {
    let id: String
    let name: String
    let arabicName: String
    let editionKey: String
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
            editionKey: "eng-bukhari", icon: "book.closed.fill",
            description: "The most authentic collection of Hadith",
            descriptionArabic: "أصح كتب الحديث"
        ),
        HadithCollection(
            id: "muslim", name: "Sahih Muslim", arabicName: "صحيح مسلم",
            editionKey: "eng-muslim", icon: "book.closed.fill",
            description: "The second most authentic Hadith collection",
            descriptionArabic: "ثاني أصح كتب الحديث"
        ),
        HadithCollection(
            id: "abudawud", name: "Sunan Abu Dawud", arabicName: "سنن أبي داود",
            editionKey: "eng-abudawud", icon: "text.book.closed.fill",
            description: "One of the six major Hadith collections",
            descriptionArabic: "أحد الكتب الستة"
        ),
        HadithCollection(
            id: "tirmidhi", name: "Jami at-Tirmidhi", arabicName: "جامع الترمذي",
            editionKey: "eng-tirmidhi", icon: "text.book.closed.fill",
            description: "Collection by Imam at-Tirmidhi",
            descriptionArabic: "جمع الإمام الترمذي"
        ),
        HadithCollection(
            id: "nasai", name: "Sunan an-Nasa'i", arabicName: "سنن النسائي",
            editionKey: "eng-nasai", icon: "text.book.closed.fill",
            description: "Collection by Imam an-Nasa'i",
            descriptionArabic: "جمع الإمام النسائي"
        ),
        HadithCollection(
            id: "ibnmajah", name: "Sunan Ibn Majah", arabicName: "سنن ابن ماجه",
            editionKey: "eng-ibnmajah", icon: "text.book.closed.fill",
            description: "Collection by Imam Ibn Majah",
            descriptionArabic: "جمع الإمام ابن ماجه"
        ),
    ]
}

// MARK: - API Response Models
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
