import SwiftUI
import CoreLocation
import MapKit

@Observable
final class PrayerTimesViewModel {
    // MARK: - Properties
    var prayerTimes: [PrayerTimeEntry] = []
    var trackingDays: [PrayerTrackingDay] = []
    var selectedDate: Date = Date()
    var locationName: String = "Loading..."
    /// Set when API fetch fails and fallback to local calculation was used; nil when API succeeded.
    var lastPrayerTimesError: String?

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
    private let prayerTimesService = PrayerTimesService.shared

    /// Calculation method for the Aladhan API (configurable; persisted in UserDefaults).
    var calculationMethod: AladhanCalculationMethod {
        get {
            let raw = UserDefaults.standard.integer(forKey: "prayer_calculation_method")
            return AladhanCalculationMethod(rawValue: raw) ?? .ummAlQura
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "prayer_calculation_method")
        }
    }

    func calculatePrayerTimes() {
        let location = locationService.currentLocation
        let lat = location?.coordinate.latitude ?? 21.4225
        let lon = location?.coordinate.longitude ?? 39.8262

        prayerTimes = PrayerTimeCalculator.calculatePrayerTimes(
            for: selectedDate,
            latitude: lat,
            longitude: lon
        )
        updateLiveActivityIfNeeded()

        if location != nil {
            reverseGeocode(location!)
        } else {
            locationName = LanguageManager.shared.localized("Makkah (Default)", arabic: "مكة المكرمة (افتراضي)")
        }
    }

    /// Fetches prayer times dynamically from Aladhan API (latitude, longitude, current date, method). Falls back to local calculation on error.
    func fetchPrayerTimes() async {
        let location = locationService.currentLocation
        let lat = location?.coordinate.latitude ?? 21.4225
        let lon = location?.coordinate.longitude ?? 39.8262

        do {
            let result = try await prayerTimesService.fetchPrayerTimes(
                date: selectedDate,
                latitude: lat,
                longitude: lon,
                method: calculationMethod
            )
            prayerTimes = result.timings
            lastPrayerTimesError = nil
            updateLiveActivityIfNeeded()
            if location != nil {
                reverseGeocode(location!)
            } else {
                locationName = LanguageManager.shared.localized("Makkah (Default)", arabic: "مكة المكرمة (افتراضي)")
            }
        } catch {
            lastPrayerTimesError = (error as? PrayerTimesServiceError)?.errorDescription ?? error.localizedDescription
            calculatePrayerTimes()
        }
    }

    func requestLocation() {
        locationService.requestPermission()
        locationService.startUpdatingLocation()
    }

    private func reverseGeocode(_ location: CLLocation) {
        if #available(iOS 26.0, *) {
            guard let request = MKReverseGeocodingRequest(location: location) else { return }
            request.getMapItems { [weak self] mapItems, _ in
                guard let item = mapItems?.first else { return }
                let city = item.placemark.locality
                let country = item.placemark.country
                if let city = city, let country = country {
                    self?.locationName = "\(city), \(country)"
                }
            }
        } else {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
                if let city = placemarks?.first?.locality,
                   let country = placemarks?.first?.country {
                    self?.locationName = "\(city), \(country)"
                }
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
        updateLiveActivityIfNeeded()
    }

    func isPrayerCompleted(_ prayer: Prayer) -> Bool {
        todayTracking.isCompleted(prayer)
    }

    // MARK: - Persistence (App Group for widget)
    private static let appGroupID = "group.com.Areeb.MuslimHub"
    private var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: Self.appGroupID)
    }

    private func saveTracking() {
        guard let data = try? JSONEncoder().encode(trackingDays) else { return }
        sharedDefaults?.set(data, forKey: "prayer_tracking")
        sharedDefaults?.synchronize()
        UserDefaults.standard.set(data, forKey: "prayer_tracking")
    }

    private func loadTracking() {
        let data = sharedDefaults?.data(forKey: "prayer_tracking")
            ?? UserDefaults.standard.data(forKey: "prayer_tracking")
        guard let data = data,
              let saved = try? JSONDecoder().decode([PrayerTrackingDay].self, from: data) else { return }
        trackingDays = saved
    }

    // MARK: - Live Activity
    func updateLiveActivityIfNeeded() {
        guard #available(iOS 16.2, *) else { return }
        let completed = todayTracking.completedPrayers.count
        let nextName = nextPrayer?.prayer.localizedName ?? "—"
        let nextTime = nextPrayer?.timeString ?? "—"
        LiveActivityManager.shared.startOrUpdate(
            completedCount: completed,
            nextPrayerName: nextName,
            nextPrayerTime: nextTime
        )
        // Cache for Lock Screen / Dynamic Island when app launches from cold
        sharedDefaults?.set(nextName, forKey: "last_next_prayer_name")
        sharedDefaults?.set(nextTime, forKey: "last_next_prayer_time")
        sharedDefaults?.synchronize()
    }
}
