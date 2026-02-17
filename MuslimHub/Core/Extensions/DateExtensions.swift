import Foundation

extension Date {
    // MARK: - Hijri Calendar
    var hijriCalendar: Calendar {
        var calendar = Calendar(identifier: .islamicUmmAlQura)
        calendar.locale = Locale(identifier: "ar")
        return calendar
    }

    var hijriDate: String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: LanguageManager.shared.currentLanguage == .arabic ? "ar" : "en")
        return formatter.string(from: self)
    }

    var hijriDay: Int {
        hijriCalendar.component(.day, from: self)
    }

    var hijriMonth: Int {
        hijriCalendar.component(.month, from: self)
    }

    var hijriYear: Int {
        hijriCalendar.component(.year, from: self)
    }

    var hijriMonthName: String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        formatter.locale = Locale(identifier: LanguageManager.shared.currentLanguage == .arabic ? "ar" : "en")
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }

    var gregorianFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: LanguageManager.shared.currentLanguage == .arabic ? "ar" : "en")
        return formatter.string(from: self)
    }

    var timeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.locale = Locale(identifier: "en")
        return formatter.string(from: self)
    }

    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: LanguageManager.shared.currentLanguage == .arabic ? "ar" : "en")
        return formatter.string(from: self)
    }
}
