//
//  MuslimHubWidgetLiveActivity.swift
//  MuslimHubWidget
//

import ActivityKit
import WidgetKit
import SwiftUI

// MARK: - Live Activity (Lock Screen + Dynamic Island) – uses PrayerProgressAttributes from main app
struct PrayerProgressLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PrayerProgressAttributes.self) { context in
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    HStack(spacing: 12) {
                        Text("\(context.state.completedCount)/5")
                            .font(.title2.bold())
                            .foregroundStyle(WidgetShared.themeGreen)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Next: \(context.state.nextPrayerName)")
                                .font(.caption.weight(.medium))
                            Text(context.state.nextPrayerTime)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        ProgressView(value: context.state.progress)
                            .tint(WidgetShared.themeGreen)
                            .frame(width: 44)
                    }
                    .padding(.horizontal, 4)
                }
            } compactLeading: {
                Image(systemName: "moon.stars.fill")
                    .foregroundStyle(WidgetShared.themeGreen)
            } compactTrailing: {
                Text("\(context.state.completedCount)/5")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(WidgetShared.themeGreen)
            } minimal: {
                Image(systemName: "moon.stars.fill")
                    .foregroundStyle(WidgetShared.themeGreen)
            }
        }
    }
}

struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<PrayerProgressAttributes>

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Prayer Progress")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(context.state.completedCount) of 5 completed")
                    .font(.subheadline.weight(.semibold))
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("Next: \(context.state.nextPrayerName)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(context.state.nextPrayerTime)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(WidgetShared.themeGreen)
            }
            ProgressView(value: context.state.progress)
                .tint(WidgetShared.themeGreen)
                .frame(width: 48)
                .scaleEffect(y: 1.2, anchor: .center)
        }
        .padding()
    }
}
