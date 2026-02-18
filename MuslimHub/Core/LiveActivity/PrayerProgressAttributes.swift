import ActivityKit
import Foundation

// MARK: - Live Activity model (must match widget extension if duplicated there)
struct PrayerProgressAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var completedCount: Int
        var nextPrayerName: String
        var nextPrayerTime: String
        var progress: Double
    }

    // Static data (optional)
    var totalPrayers: Int = 5
}
