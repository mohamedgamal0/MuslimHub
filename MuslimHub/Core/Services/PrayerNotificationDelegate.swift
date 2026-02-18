import UserNotifications

/// Handles prayer notifications: plays Adhan sound in-app when notification is received (works with .mp3).
/// Delegate is set in AppDelegate at launch.
final class PrayerNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = PrayerNotificationDelegate()

    /// Set when user taps a prayer notification; AppDelegate plays Adhan when app becomes active.
    static var shouldPlayAdhanOnBecomeActive = false

    override private init() {
        super.init()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        if notification.request.content.categoryIdentifier == "PRAYER_REMINDER" {
            AdhanSoundPlayer.shared.playIfAvailable()
            completionHandler([.banner, .badge, .list])
            return
        }
        completionHandler([.banner, .sound, .badge, .list])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        if response.notification.request.content.categoryIdentifier == "PRAYER_REMINDER" {
            Self.shouldPlayAdhanOnBecomeActive = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                AdhanSoundPlayer.shared.playIfAvailable()
            }
        }
        completionHandler()
    }
}
