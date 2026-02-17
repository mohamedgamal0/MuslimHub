import ActivityKit
import Foundation

@Observable
final class LiveActivityManager {
    static let shared = LiveActivityManager()
    private static let appGroupID = "group.com.Areeb.MuslimHub"

    private(set) var currentActivity: Activity<PrayerProgressAttributes>?

    private init() {}

    /// Start or refresh Live Activity from App Group data (for Lock Screen / Dynamic Island when app launches or becomes active).
    func updateFromAppGroup() {
        guard #available(iOS 16.2, *) else { return }
        let defaults = UserDefaults(suiteName: Self.appGroupID)
        let completed: Int = {
            guard let data = defaults?.data(forKey: "prayer_tracking"),
                  let days = try? JSONDecoder().decode([PrayerTrackingDay].self, from: data) else {
                return 0
            }
            let calendar = Calendar.current
            guard let today = days.first(where: { calendar.isDate($0.date, inSameDayAs: Date()) }) else {
                return 0
            }
            return today.completedPrayers.count
        }()
        let nextName = defaults?.string(forKey: "last_next_prayer_name") ?? "—"
        let nextTime = defaults?.string(forKey: "last_next_prayer_time") ?? "—"
        startOrUpdate(completedCount: completed, nextPrayerName: nextName, nextPrayerTime: nextTime)
    }

    func startOrUpdate(completedCount: Int, nextPrayerName: String, nextPrayerTime: String) {
        let progress = min(1.0, Double(completedCount) / 5.0)
        let state = PrayerProgressAttributes.ContentState(
            completedCount: completedCount,
            nextPrayerName: nextPrayerName,
            nextPrayerTime: nextPrayerTime,
            progress: progress
        )
        Task {
            await performStartOrUpdate(state: state)
        }
    }

    @MainActor
    private func performStartOrUpdate(state: PrayerProgressAttributes.ContentState) async {
        if let activity = currentActivity {
            await activity.update(ActivityContent(state: state, staleDate: nil))
        } else {
            let att = PrayerProgressAttributes()
            do {
                let activity = try await Activity.request(
                    attributes: att,
                    content: ActivityContent(state: state, staleDate: nil),
                    pushType: nil
                )
                currentActivity = activity
            } catch {
                currentActivity = nil
            }
        }
    }

    func end() {
        Task {
            await currentActivity?.end(nil, dismissalPolicy: .immediate)
            await MainActor.run { currentActivity = nil }
        }
    }
}
