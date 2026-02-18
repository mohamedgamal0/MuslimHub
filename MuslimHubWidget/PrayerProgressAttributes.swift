import ActivityKit
import Foundation

// Must match main app's PrayerProgressAttributes for Live Activity updates
struct PrayerProgressAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var completedCount: Int
        var nextPrayerName: String
        var nextPrayerTime: String
        var progress: Double
    }
    var totalPrayers: Int = 5
}
