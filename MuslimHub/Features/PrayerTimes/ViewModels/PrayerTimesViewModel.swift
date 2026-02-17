import SwiftUI
import CoreLocation

@Observable
final class PrayerTimesViewModel {
    // MARK: - Properties
    var prayerTimes: [PrayerTimeEntry] = []
    var trackingDays: [PrayerTrackingDay] = []
    var selectedDate: Date = Date()
    var locationName: String = "Loading..."

    private let locationService = LocationService.shared

    // MARK: - Computed
    var nextPrayer: PrayerTimeEntry? {
        prayerTimes.first(where: \.isNext)
    }

    var timeUntilNextPrayer: String {
        guard let next = nextPrayer else { return "--:--" }
        let interval = next.time.timeIntervalSince(Date())
        guard interval > 0 else { return "Now" }
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    var todayTracking: PrayerTrackingDay {
        let calendar = Calendar.current
        if let today = trackingDays.first(where: { calendar.isDate($0.date, inSameDayAs: Date()) }) {
            return today
        }
        return PrayerTrackingDay()
    }

    var weeklyCompletionRate: Double {
        guard !trackingDays.isEmpty else { return 0 }
        let last7 = Array(trackingDays.suffix(7))
        let total = last7.reduce(0.0) { $0 + $1.completionRate }
        return total / Double(last7.count)
    }

    // MARK: - Init
    init() {
        loadTracking()
        calculatePrayerTimes()
    }

    // MARK: - Prayer Time Calculation
    func calculatePrayerTimes() {
        let location = locationService.currentLocation
        let lat = location?.coordinate.latitude ?? 21.4225
        let lon = location?.coordinate.longitude ?? 39.8262

        prayerTimes = PrayerTimeCalculator.calculatePrayerTimes(
            for: selectedDate,
            latitude: lat,
            longitude: lon
        )

        if location != nil {
            reverseGeocode(location!)
        } else {
            locationName = LanguageManager.shared.localized("Makkah (Default)", arabic: "مكة المكرمة (افتراضي)")
        }
    }

    func requestLocation() {
        locationService.requestPermission()
        locationService.startUpdatingLocation()
    }

    private func reverseGeocode(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            if let city = placemarks?.first?.locality,
               let country = placemarks?.first?.country {
                self?.locationName = "\(city), \(country)"
            }
        }
    }

    // MARK: - Prayer Tracking
    func togglePrayerCompletion(_ prayer: Prayer) {
        let calendar = Calendar.current

        if let index = trackingDays.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: Date()) }) {
            if trackingDays[index].completedPrayers.contains(prayer.rawValue) {
                trackingDays[index].completedPrayers.remove(prayer.rawValue)
            } else {
                trackingDays[index].completedPrayers.insert(prayer.rawValue)
            }
        } else {
            let newDay = PrayerTrackingDay(
                date: Date(),
                completedPrayers: [prayer.rawValue]
            )
            trackingDays.append(newDay)
        }

        saveTracking()
    }

    func isPrayerCompleted(_ prayer: Prayer) -> Bool {
        todayTracking.isCompleted(prayer)
    }

    // MARK: - Persistence
    private func saveTracking() {
        if let data = try? JSONEncoder().encode(trackingDays) {
            UserDefaults.standard.set(data, forKey: "prayer_tracking")
        }
    }

    private func loadTracking() {
        if let data = UserDefaults.standard.data(forKey: "prayer_tracking"),
           let saved = try? JSONDecoder().decode([PrayerTrackingDay].self, from: data) {
            trackingDays = saved
        }
    }
}
