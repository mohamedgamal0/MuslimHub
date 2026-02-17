import SwiftUI
import WidgetKit

enum WidgetShared {
    static let appGroupID = "group.com.Areeb.MuslimHub"

    static var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }

    static func loadTracking() -> (completed: Int, total: Int) {
        guard let data = sharedDefaults?.data(forKey: "prayer_tracking") else {
            return (0, 5)
        }
        struct Day: Codable {
            let date: Date
            let completedPrayers: [String]
        }
        let calendar = Calendar.current
        guard let decoded = try? JSONDecoder().decode([Day].self, from: data),
              let today = decoded.first(where: { calendar.isDate($0.date, inSameDayAs: Date()) }) else {
            return (0, 5)
        }
        return (today.completedPrayers.count, 5)
    }

    static let themeGreen = Color(red: 0.106, green: 0.420, blue: 0.302)
}
