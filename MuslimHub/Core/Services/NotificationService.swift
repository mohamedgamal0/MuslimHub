import Foundation
import UserNotifications

struct SavedPrayerTime: Codable {
    let prayer: String
    let time: Double
}

actor NotificationService {
    static let shared = NotificationService()

    private init() {}

    // MARK: - Permission
    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            return granted
        } catch {
            return false
        }
    }

    func checkPermission() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }

    // MARK: - Prayer Time Notifications (Adhan sound)

    /// Sound for when the notification is delivered (plays even when app is in background).
    /// Uses .caf/.wav/.aiff from bundle, or converts adhanNotification.mp3 → CAF in Library/Sounds.
    private static var adhanSound: UNNotificationSound {
        if let name = AdhanNotificationSoundConverter.prepareNotificationSound() {
            return UNNotificationSound(named: UNNotificationSoundName(name))
        }
        return .default
    }

    /// Call from Settings to show whether custom Adhan file was found. Includes .mp3 (played in-app when notification is received).
    static func isCustomAdhanSoundInBundle() -> Bool {
        let candidates: [(base: String, ext: String)] = [
            ("adhanNotification", "mp3"),
            ("adhanNotification", "caf"),
            ("adhanNotification", "wav"),
            ("adhanNotification", "aiff"),
        ]
        return candidates.contains { Bundle.main.url(forResource: $0.base, withExtension: $0.ext) != nil }
    }

    /// Schedules one-time prayer notifications at the given times, using Adhan sound. Only future times are scheduled. Call this when prayer times are loaded for today.
    func schedulePrayerNotifications(items: [(identifier: String, prayerName: String, fireDate: Date)]) async {
        cancelAllPrayerNotifications()

        let calendar = Calendar.current
        let now = Date()

        for item in items {
            guard item.fireDate > now else { continue }

            let content = UNMutableNotificationContent()
            content.title = "Prayer Time"
            content.body = "It's time for \(item.prayerName) prayer"
            content.sound = Self.adhanSound
            content.categoryIdentifier = "PRAYER_REMINDER"

            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: item.fireDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

            let request = UNNotificationRequest(
                identifier: "prayer_\(item.identifier)",
                content: content,
                trigger: trigger
            )

            do {
                try await UNUserNotificationCenter.current().add(request)
            } catch {
                print("Failed to schedule prayer notification \(item.identifier): \(error)")
            }
        }
    }

    /// Schedules prayer notifications from the last saved times (e.g. when user enables Prayer Notifications in Settings). Uses Adhan sound.
    func schedulePrayerNotificationsFromSavedTimes() async {
        let key = "saved_prayer_times_for_notifications"
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode([SavedPrayerTime].self, from: data) else { return }

        let items: [(identifier: String, prayerName: String, fireDate: Date)] = saved.map { s in
            (identifier: s.prayer.lowercased(), prayerName: s.prayer, fireDate: Date(timeIntervalSince1970: s.time))
        }
        await schedulePrayerNotifications(items: items)
    }

    /// Call from ViewModel when prayer times are updated for today, so enabling notifications later can use them.
    func savePrayerTimesForScheduling(_ entries: [SavedPrayerTime]) {
        let key = "saved_prayer_times_for_notifications"
        guard let encoded = try? JSONEncoder().encode(entries) else { return }
        UserDefaults.standard.set(encoded, forKey: key)
    }

    // MARK: - Doaa Reminders
    func scheduleDoaaReminder(
        title: String,
        body: String,
        hour: Int,
        minute: Int,
        identifier: String
    ) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.categoryIdentifier = "DOAA_REMINDER"

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: "doaa_\(identifier)",
            content: content,
            trigger: trigger
        )

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to schedule doaa reminder: \(error)")
        }
    }

    // MARK: - Cancel
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func cancelAllPrayerNotifications() {
        let identifiers = ["prayer_fajr", "prayer_dhuhr", "prayer_asr", "prayer_maghrib", "prayer_isha"]
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    func cancelAllDoaaReminders() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["doaa_morning", "doaa_evening"])
    }

}
