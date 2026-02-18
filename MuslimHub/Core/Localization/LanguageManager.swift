import SwiftUI

// MARK: - Supported Languages
enum AppLanguage: String, CaseIterable, Codable {
    case english = "en"
    case arabic = "ar"

    var displayName: String {
        switch self {
        case .english: return "English"
        case .arabic: return "العربية"
        }
    }

    var isRTL: Bool {
        self == .arabic
    }

    var layoutDirection: LayoutDirection {
        isRTL ? .rightToLeft : .leftToRight
    }
}

// MARK: - Language Manager (System-based)
@Observable
final class LanguageManager {
    static let shared = LanguageManager()

    var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "app_language")
        }
    }

    var layoutDirection: LayoutDirection {
        currentLanguage.layoutDirection
    }

    private init() {
        let systemLang = Bundle.main.preferredLocalizations.first ?? Locale.current.language.languageCode?.identifier ?? "en"
        if systemLang.hasPrefix("ar") {
            self.currentLanguage = .arabic
        } else if let saved = UserDefaults.standard.string(forKey: "app_language"),
                  let lang = AppLanguage(rawValue: saved) {
            self.currentLanguage = lang
        } else {
            self.currentLanguage = .english
        }
    }

    func localized(_ english: String, arabic: String) -> String {
        currentLanguage == .english ? english : arabic
    }
}

// MARK: - Localized Strings
enum L10n {
    static var lang: LanguageManager { LanguageManager.shared }

    // Tab Bar
    static var quran: String { lang.localized("Quran", arabic: "القرآن") }
    static var doaa: String { lang.localized("Doaa", arabic: "الدعاء") }
    static var prayerTimes: String { lang.localized("Prayer", arabic: "الصلاة") }
    static var settings: String { lang.localized("Settings", arabic: "الإعدادات") }
    static var hadith: String { lang.localized("Hadith", arabic: "الحديث") }

    // Quran
    static var surahList: String { lang.localized("Surahs", arabic: "السور") }
    static var ayah: String { lang.localized("Ayah", arabic: "آية") }
    static var ayahs: String { lang.localized("Ayahs", arabic: "آيات") }
    static var juz: String { lang.localized("Juz", arabic: "جزء") }
    static var bookmark: String { lang.localized("Bookmark", arabic: "إشارة مرجعية") }
    static var bookmarks: String { lang.localized("Bookmarks", arabic: "الإشارات المرجعية") }
    static var play: String { lang.localized("Play", arabic: "تشغيل") }
    static var pause: String { lang.localized("Pause", arabic: "إيقاف") }
    static var searchQuran: String { lang.localized("Search Quran...", arabic: "البحث في القرآن...") }
    static var meccan: String { lang.localized("Meccan", arabic: "مكية") }
    static var medinan: String { lang.localized("Medinan", arabic: "مدنية") }
    static var verses: String { lang.localized("verses", arabic: "آيات") }
    static var loading: String { lang.localized("Loading...", arabic: "جاري التحميل...") }
    static var retry: String { lang.localized("Retry", arabic: "إعادة المحاولة") }
    static var pullToRefresh: String { lang.localized("Pull to refresh", arabic: "اسحب للتحديث") }

    // Doaa
    static var morningAzkar: String { lang.localized("Morning Azkar", arabic: "أذكار الصباح") }
    static var eveningAzkar: String { lang.localized("Evening Azkar", arabic: "أذكار المساء") }
    static var travelDoaa: String { lang.localized("Travel Doaa", arabic: "دعاء السفر") }
    static var healthDoaa: String { lang.localized("Health Doaa", arabic: "دعاء الشفاء") }
    static var generalDoaa: String { lang.localized("General Doaa", arabic: "أدعية عامة") }
    static var favorites: String { lang.localized("Favorites", arabic: "المفضلة") }
    static var dailySupplications: String { lang.localized("Daily Supplications", arabic: "الأذكار اليومية") }
    static var categories: String { lang.localized("Categories", arabic: "التصنيفات") }
    static var repeatCount: String { lang.localized("Repeat", arabic: "التكرار") }

    // Hadith
    static var hadithCollections: String { lang.localized("Hadith Collections", arabic: "كتب الحديث") }
    static var chapters: String { lang.localized("Chapters", arabic: "الأبواب") }
    static var hadithNumber: String { lang.localized("Hadith", arabic: "حديث") }
    static var searchHadith: String { lang.localized("Search Hadith...", arabic: "البحث في الأحاديث...") }

    // Prayer Times
    static var fajr: String { lang.localized("Fajr", arabic: "الفجر") }
    static var sunrise: String { lang.localized("Sunrise", arabic: "الشروق") }
    static var dhuhr: String { lang.localized("Dhuhr", arabic: "الظهر") }
    static var asr: String { lang.localized("Asr", arabic: "العصر") }
    static var maghrib: String { lang.localized("Maghrib", arabic: "المغرب") }
    static var isha: String { lang.localized("Isha", arabic: "العشاء") }
    static var nextPrayer: String { lang.localized("Next Prayer", arabic: "الصلاة القادمة") }
    static var qiblaDirection: String { lang.localized("Qibla Direction", arabic: "اتجاه القبلة") }
    static var hijriCalendar: String { lang.localized("Hijri Calendar", arabic: "التقويم الهجري") }
    static var prayerTracking: String { lang.localized("Tracking", arabic: "المتابعة") }

    // Settings
    static var darkMode: String { lang.localized("Dark Mode", arabic: "الوضع الداكن") }
    static var language: String { lang.localized("Language", arabic: "اللغة") }
    static var notifications: String { lang.localized("Notifications", arabic: "الإشعارات") }
    static var about: String { lang.localized("About", arabic: "حول التطبيق") }
    static var appearance: String { lang.localized("Appearance", arabic: "المظهر") }
    static var general: String { lang.localized("General", arabic: "عام") }
    static var prayerNotifications: String { lang.localized("Prayer Notifications", arabic: "إشعارات الصلاة") }
    static var doaaReminders: String { lang.localized("Doaa Reminders", arabic: "تذكير بالدعاء") }
    static var version: String { lang.localized("Version", arabic: "الإصدار") }
}
