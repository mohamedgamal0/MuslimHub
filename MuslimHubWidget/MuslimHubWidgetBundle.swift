//
//  MuslimHubWidgetBundle.swift
//  MuslimHubWidget
//
//  Created by Mohamed Gamal on 17/02/2026.
//

import WidgetKit
import SwiftUI

@main
struct MuslimHubWidgetBundle: WidgetBundle {
    var body: some Widget {
        PrayerProgressWidget()
        PrayerProgressLiveActivity()
    }
}
