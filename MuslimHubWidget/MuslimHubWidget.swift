//
//  MuslimHubWidget.swift
//  MuslimHubWidget
//

import WidgetKit
import SwiftUI

// MARK: - Static Widget (Prayer Progress)
struct PrayerProgressWidget: Widget {
    let kind: String = "PrayerProgressWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PrayerProgressProvider()) { entry in
            PrayerProgressWidgetView(entry: entry)
        }
        .configurationDisplayName("Prayer Progress")
        .description("See today's prayer completion at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct PrayerProgressEntry: TimelineEntry {
    let date: Date
    let completedCount: Int
    let totalCount: Int
}

struct PrayerProgressProvider: TimelineProvider {
    func placeholder(in context: Context) -> PrayerProgressEntry {
        PrayerProgressEntry(date: Date(), completedCount: 2, totalCount: 5)
    }

    func getSnapshot(in context: Context, completion: @escaping (PrayerProgressEntry) -> Void) {
        let (completed, total) = WidgetShared.loadTracking()
        completion(PrayerProgressEntry(date: Date(), completedCount: completed, totalCount: total))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PrayerProgressEntry>) -> Void) {
        let (completed, total) = WidgetShared.loadTracking()
        let entry = PrayerProgressEntry(date: Date(), completedCount: completed, totalCount: total)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }
}

struct PrayerProgressWidgetView: View {
    @Environment(\.widgetFamily) var family
    let entry: PrayerProgressEntry

    var body: some View {
        let (completed, total) = (entry.completedCount, entry.totalCount)
        let progress = total > 0 ? Double(completed) / Double(total) : 0

        switch family {
        case .systemSmall:
            smallView(completed: completed, total: total, progress: progress)
        case .systemMedium:
            mediumView(completed: completed, total: total, progress: progress)
        default:
            smallView(completed: completed, total: total, progress: progress)
        }
    }

    private func smallView(completed: Int, total: Int, progress: Double) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "moon.stars.fill")
                .font(.title2)
                .foregroundStyle(WidgetShared.themeGreen)
            Text("Prayer Progress")
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
            Text("\(completed)/\(total)")
                .font(.title2.bold())
                .foregroundStyle(WidgetShared.themeGreen)
            ProgressView(value: progress)
                .tint(WidgetShared.themeGreen)
                .scaleEffect(y: 1.5, anchor: .center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func mediumView(completed: Int, total: Int, progress: Double) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 6)
                    .frame(width: 56, height: 56)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(WidgetShared.themeGreen, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 56, height: 56)
                    .rotationEffect(.degrees(-90))
                Text("\(completed)")
                    .font(.title2.bold())
                    .foregroundStyle(WidgetShared.themeGreen)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Today's Progress")
                    .font(.subheadline.weight(.semibold))
                Text("\(completed) of \(total) prayers completed")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                ProgressView(value: progress)
                    .tint(WidgetShared.themeGreen)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview("Static Small", as: .systemSmall) {
    PrayerProgressWidget()
} timeline: {
    PrayerProgressEntry(date: .now, completedCount: 3, totalCount: 5)
}
