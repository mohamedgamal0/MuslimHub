import SwiftUI
import UIKit

@Observable
final class SettingsViewModel {
    static let shared = SettingsViewModel()

    // MARK: - Appearance
    var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "dark_mode")
            Self.applyAppearance(dark: isDarkMode)
        }
    }

    /// Apply dark/light mode to all windows so it works on both simulator and real device.
    static func applyAppearance(dark: Bool) {
        let style: UIUserInterfaceStyle = dark ? .dark : .light
        DispatchQueue.main.async {
            for scene in UIApplication.shared.connectedScenes {
                guard let windowScene = scene as? UIWindowScene else { continue }
                for window in windowScene.windows {
                    window.overrideUserInterfaceStyle = style
                }
            }
        }
    }

    // MARK: - Notifications
    var prayerNotificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(prayerNotificationsEnabled, forKey: "prayer_notifications")
            Task { await updatePrayerNotifications() }
        }
    }

    var doaaRemindersEnabled: Bool {
        didSet {
            UserDefaults.standard.set(doaaRemindersEnabled, forKey: "doaa_reminders")
            Task { await updateDoaaReminders() }
        }
    }

    var morningReminderTime: Date {
        didSet {
            UserDefaults.standard.set(morningReminderTime.timeIntervalSince1970, forKey: "morning_reminder_time")
        }
    }

    var eveningReminderTime: Date {
        didSet {
            UserDefaults.standard.set(eveningReminderTime.timeIntervalSince1970, forKey: "evening_reminder_time")
        }
    }

    // MARK: - About
    let appVersion = "1.0.0"
    let buildNumber = "1"

    // MARK: - Init
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "dark_mode")
        self.prayerNotificationsEnabled = UserDefaults.standard.bool(forKey: "prayer_notifications")
        self.doaaRemindersEnabled = UserDefaults.standard.bool(forKey: "doaa_reminders")

        let morningInterval = UserDefaults.standard.double(forKey: "morning_reminder_time")
        if morningInterval > 0 {
            self.morningReminderTime = Date(timeIntervalSince1970: morningInterval)
        } else {
            var components = DateComponents()
            components.hour = 6
            components.minute = 0
            self.morningReminderTime = Calendar.current.date(from: components) ?? Date()
        }

        let eveningInterval = UserDefaults.standard.double(forKey: "evening_reminder_time")
        if eveningInterval > 0 {
            self.eveningReminderTime = Date(timeIntervalSince1970: eveningInterval)
        } else {
            var components = DateComponents()
            components.hour = 18
            components.minute = 0
            self.eveningReminderTime = Calendar.current.date(from: components) ?? Date()
        }

        Self.applyAppearance(dark: isDarkMode)
    }

    // MARK: - Notification Actions
    func requestNotificationPermission() async -> Bool {
        await NotificationService.shared.requestPermission()
    }

    private func updatePrayerNotifications() async {
        if prayerNotificationsEnabled {
            _ = await requestNotificationPermission()
            await NotificationService.shared.schedulePrayerNotificationsFromSavedTimes()
        } else {
            await NotificationService.shared.cancelAllPrayerNotifications()
        }
    }

    private func updateDoaaReminders() async {
        if doaaRemindersEnabled {
            let granted = await requestNotificationPermission()
            if granted {
                let morningComponents = Calendar.current.dateComponents([.hour, .minute], from: morningReminderTime)
                await NotificationService.shared.scheduleDoaaReminder(
                    title: "Morning Azkar",
                    body: "Start your day with morning remembrance",
                    hour: morningComponents.hour ?? 6,
                    minute: morningComponents.minute ?? 0,
                    identifier: "morning"
                )

                let eveningComponents = Calendar.current.dateComponents([.hour, .minute], from: eveningReminderTime)
                await NotificationService.shared.scheduleDoaaReminder(
                    title: "Evening Azkar",
                    body: "Time for evening remembrance",
                    hour: eveningComponents.hour ?? 18,
                    minute: eveningComponents.minute ?? 0,
                    identifier: "evening"
                )
            }
        } else {
            await NotificationService.shared.cancelAllDoaaReminders()
        }
    }
}
