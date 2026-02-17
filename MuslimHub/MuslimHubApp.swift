import SwiftUI
import UIKit

@main
struct MuslimHubApp: App {
    init() {
        // Tab bar: unselected items use theme green (muted)
        let themeGreen = UIColor(red: 0.106, green: 0.420, blue: 0.302, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = themeGreen.withAlphaComponent(0.55)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
