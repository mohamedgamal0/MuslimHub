import Foundation

// MARK: - Aladhan → PrayerTimeEntry
extension AladhanTimings {
    /// Convert API timings to app's PrayerTimeEntry array for the given date (in device timezone).
    func toPrayerTimeEntries(for date: Date) -> [PrayerTimeEntry] {
        let calendar = Calendar.current
        guard let baseDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: date)) else {
            return []
        }

        func parseTime(_ string: String?) -> Date? {
            guard let string = string, string.count >= 5 else { return nil }
            let parts = string.split(separator: ":")
            guard parts.count >= 2,
                  let h = Int(parts[0]),
                  let m = Int(parts[1]) else { return nil }
            return calendar.date(bySettingHour: h, minute: m, second: 0, of: baseDate)
        }

        var list: [PrayerTimeEntry] = []
        if let t = parseTime(Fajr) { list.append(PrayerTimeEntry(prayer: .fajr, time: t)) }
        if let t = parseTime(Sunrise) { list.append(PrayerTimeEntry(prayer: .sunrise, time: t)) }
        if let t = parseTime(Dhuhr) { list.append(PrayerTimeEntry(prayer: .dhuhr, time: t)) }
        if let t = parseTime(Asr) { list.append(PrayerTimeEntry(prayer: .asr, time: t)) }
        if let t = parseTime(Maghrib) { list.append(PrayerTimeEntry(prayer: .maghrib, time: t)) }
        if let t = parseTime(Isha) { list.append(PrayerTimeEntry(prayer: .isha, time: t)) }

        let now = Date()
        var nextSet = false
        for i in list.indices {
            if !nextSet && list[i].time > now {
                list[i].isNext = true
                nextSet = true
            }
        }
        return list
    }
}

// MARK: - Aladhan API Response (https://api.aladhan.com/v1/timings/...)
struct AladhanTimingsResponse: Codable {
    let code: Int?
    let status: String?
    let data: AladhanTimingsData?
}

struct AladhanTimingsData: Codable {
    let timings: AladhanTimings?
    let date: AladhanDate?
    let meta: AladhanMeta?
}

struct AladhanTimings: Codable {
    let Fajr: String?
    let Sunrise: String?
    let Dhuhr: String?
    let Asr: String?
    let Sunset: String?
    let Maghrib: String?
    let Isha: String?
    let Imsak: String?
    let Midnight: String?
}

struct AladhanDate: Codable {
    let readable: String?
    let timestamp: String?
    let hijri: AladhanHijri?
    let gregorian: AladhanGregorian?
}

struct AladhanHijri: Codable {
    let date: String?
    let day: String?
    let month: AladhanMonth?
    let year: String?
}

struct AladhanGregorian: Codable {
    let date: String?
    let day: String?
    let month: AladhanMonth?
    let year: String?
}

struct AladhanMonth: Codable {
    let number: Int?
    let en: String?
    let ar: String?
}

struct AladhanMeta: Codable {
    let latitude: Double?
    let longitude: Double?
    let timezone: String?
}
