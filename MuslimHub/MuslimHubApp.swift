import SwiftUI
import UIKit
import UserNotifications

@main
struct MuslimHubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    init() {
        let themeGreen = UIColor(red: 39/255, green: 72/255, blue: 51/255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = themeGreen.withAlphaComponent(0.55)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

private final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = PrayerNotificationDelegate.shared
        // Convert adhanNotification.mp3 → CAF in background so notification sound plays when notification arrives
        DispatchQueue.global(qos: .utility).async {
            _ = AdhanNotificationSoundConverter.prepareNotificationSound()
        }
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if PrayerNotificationDelegate.shouldPlayAdhanOnBecomeActive {
            PrayerNotificationDelegate.shouldPlayAdhanOnBecomeActive = false
            AdhanSoundPlayer.shared.playIfAvailable()
        }
    }
}
