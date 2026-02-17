import SwiftUI
import UIKit

@main
struct MuslimHubApp: App {
    init() {
        // Tab bar: unselected items use theme green (muted)
        let themeGreen = UIColor(red: 39/255, green: 72/255, blue: 51/255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = themeGreen.withAlphaComponent(0.55)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
