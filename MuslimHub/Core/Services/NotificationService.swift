import Foundation
import UserNotifications

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

    // MARK: - Prayer Time Notifications
    func schedulePrayerNotification(
        prayerName: String,
        time: Date,
        identifier: String
    ) async {
        let content = UNMutableNotificationContent()
        content.title = "Prayer Time"
        content.body = "It's time for \(prayerName) prayer"
        content.sound = .default
        content.categoryIdentifier = "PRAYER_REMINDER"

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: "prayer_\(identifier)",
            content: content,
            trigger: trigger
        )

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to schedule prayer notification: \(error)")
        }
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
