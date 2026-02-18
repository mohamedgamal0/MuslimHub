import Foundation

// MARK: - Doaa Category
enum DoaaCategory: String, CaseIterable, Identifiable, Codable {
    case morning = "morning"
    case evening = "evening"
    case postPrayer = "postPrayer"
    case travel = "travel"
    case health = "health"
    case general = "general"
    case food = "food"
    case sleep = "sleep"
    case protection = "protection"

    var id: String { rawValue }

    var nameEnglish: String {
        switch self {
        case .morning: return "Morning Azkar"
        case .evening: return "Evening Azkar"
        case .postPrayer: return "Post Prayer"
        case .travel: return "Travel"
        case .health: return "Health & Healing"
        case .general: return "General"
        case .food: return "Food & Drink"
        case .sleep: return "Sleep"
        case .protection: return "Protection"
        }
    }

    var nameArabic: String {
        switch self {
        case .morning: return "أذكار الصباح"
        case .evening: return "أذكار المساء"
        case .postPrayer: return "أذكار بعد الصلاة"
        case .travel: return "دعاء السفر"
        case .health: return "دعاء الشفاء"
        case .general: return "أدعية عامة"
        case .food: return "دعاء الطعام"
        case .sleep: return "دعاء النوم"
        case .protection: return "أدعية الحماية"
        }
    }

    var localizedName: String {
        LanguageManager.shared.currentLanguage == .arabic ? nameArabic : nameEnglish
    }

    var icon: String {
        switch self {
        case .morning: return "sun.and.horizon.fill"
        case .evening: return "moon.stars.fill"
        case .postPrayer: return "building.columns.fill"
        case .travel: return "airplane"
        case .health: return "heart.fill"
        case .general: return "hands.sparkles.fill"
        case .food: return "fork.knife"
        case .sleep: return "bed.double.fill"
        case .protection: return "shield.fill"
        }
    }

    var gradient: [String] {
        switch self {
        case .morning: return ["green", "teal"]
        case .evening: return ["indigo", "purple"]
        case .postPrayer: return ["mint", "teal"]
        case .travel: return ["blue", "cyan"]
        case .health: return ["pink", "red"]
        case .general: return ["green", "mint"]
        case .food: return ["orange", "yellow"]
        case .sleep: return ["indigo", "blue"]
        case .protection: return ["gray", "blue"]
        }
    }
}

// MARK: - Doaa Model
struct Doaa: Identifiable, Codable, Hashable {
    let id: UUID
    let textArabic: String
    let textEnglish: String
    let transliteration: String
    let category: DoaaCategory
    let source: String
    let repeatCount: Int

    init(
        textArabic: String,
        textEnglish: String,
        transliteration: String = "",
        category: DoaaCategory,
        source: String = "",
        repeatCount: Int = 1,
        id: UUID? = nil
    ) {
        self.id = id ?? UUID()
        self.textArabic = textArabic
        self.textEnglish = textEnglish
        self.transliteration = transliteration
        self.category = category
        self.source = source
        self.repeatCount = repeatCount
    }
}
