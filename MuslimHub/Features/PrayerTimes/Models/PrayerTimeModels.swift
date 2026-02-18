import Foundation
import CoreLocation

// MARK: - Prayer
enum Prayer: String, CaseIterable, Identifiable, Codable {
    case fajr = "Fajr"
    case sunrise = "Sunrise"
    case dhuhr = "Dhuhr"
    case asr = "Asr"
    case maghrib = "Maghrib"
    case isha = "Isha"

    var id: String { rawValue }

    var localizedName: String {
        switch self {
        case .fajr: return L10n.fajr
        case .sunrise: return L10n.sunrise
        case .dhuhr: return L10n.dhuhr
        case .asr: return L10n.asr
        case .maghrib: return L10n.maghrib
        case .isha: return L10n.isha
        }
    }

    var icon: String {
        switch self {
        case .fajr: return "sun.horizon.fill"
        case .sunrise: return "sunrise.fill"
        case .dhuhr: return "sun.max.fill"
        case .asr: return "sun.min.fill"
        case .maghrib: return "sunset.fill"
        case .isha: return "moon.stars.fill"
        }
    }

    var isPrayer: Bool {
        self != .sunrise
    }
}

// MARK: - Prayer Time Entry
struct PrayerTimeEntry: Identifiable {
    let id = UUID()
    let prayer: Prayer
    let time: Date
    var isNext: Bool = false
    var isCompleted: Bool = false

    var timeString: String {
        time.timeFormatted
    }
}

// MARK: - Prayer Tracking
struct PrayerTrackingDay: Identifiable, Codable {
    let id: UUID
    let date: Date
    var completedPrayers: Set<String>

    init(date: Date = Date(), completedPrayers: Set<String> = []) {
        self.id = UUID()
        self.date = date
        self.completedPrayers = completedPrayers
    }

    var completionRate: Double {
        Double(completedPrayers.count) / 5.0
    }

    func isCompleted(_ prayer: Prayer) -> Bool {
        completedPrayers.contains(prayer.rawValue)
    }
}

// MARK: - Prayer Time Calculator
struct PrayerTimeCalculator {
    /// Basic prayer time calculation using approximate method.
    /// For production, use a proper astronomical calculation library.
    static func calculatePrayerTimes(
        for date: Date = Date(),
        latitude: Double,
        longitude: Double
    ) -> [PrayerTimeEntry] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        guard let baseDate = calendar.date(from: components) else { return [] }

        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let declination = -23.45 * cos(2 * .pi / 365.0 * Double(dayOfYear + 10))
        let declinationRad = declination * .pi / 180.0
        let latRad = latitude * .pi / 180.0

        let equationOfTime = -7.655 * sin(.pi / 180.0 * Double(dayOfYear))
            + 9.873 * sin(2 * .pi / 180.0 * Double(dayOfYear) + 3.588)

        let solarNoon = 12.0 - longitude / 15.0 - equationOfTime / 60.0

        func hourAngle(for angle: Double) -> Double {
            let cosH = (sin(angle * .pi / 180.0) - sin(latRad) * sin(declinationRad))
                / (cos(latRad) * cos(declinationRad))
            guard cosH >= -1, cosH <= 1 else { return 0 }
            return acos(cosH) * 180.0 / .pi / 15.0
        }

        let sunriseHA = hourAngle(for: -0.833)
        let fajrHA = hourAngle(for: -18.0)
        let ishaHA = hourAngle(for: -17.0)

        let asrShadowFactor = 1.0
        let asrAngle = atan(1.0 / (asrShadowFactor + tan(abs(latRad - declinationRad)))) * 180.0 / .pi
        let asrHA = hourAngle(for: asrAngle)

        func makeTime(hours: Double) -> Date {
            let adjustedHours = max(0, min(23.99, hours))
            let h = Int(adjustedHours)
            let m = Int((adjustedHours - Double(h)) * 60)
            return calendar.date(bySettingHour: h, minute: m, second: 0, of: baseDate) ?? baseDate
        }

        let fajrTime = solarNoon - fajrHA
        let sunriseTime = solarNoon - sunriseHA
        let dhuhrTime = solarNoon + 0.0167
        let asrTime = solarNoon + asrHA
        let maghribTime = solarNoon + sunriseHA
        let ishaTime = solarNoon + ishaHA

        var entries = [
            PrayerTimeEntry(prayer: .fajr, time: makeTime(hours: fajrTime)),
            PrayerTimeEntry(prayer: .sunrise, time: makeTime(hours: sunriseTime)),
            PrayerTimeEntry(prayer: .dhuhr, time: makeTime(hours: dhuhrTime)),
            PrayerTimeEntry(prayer: .asr, time: makeTime(hours: asrTime)),
            PrayerTimeEntry(prayer: .maghrib, time: makeTime(hours: maghribTime)),
            PrayerTimeEntry(prayer: .isha, time: makeTime(hours: ishaTime)),
        ]

        let now = Date()
        var nextFound = false
        for i in entries.indices {
            if !nextFound && entries[i].time > now {
                entries[i].isNext = true
                nextFound = true
            }
        }

        return entries
    }
}
