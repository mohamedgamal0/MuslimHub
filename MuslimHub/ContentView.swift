import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var settingsVM = SettingsViewModel.shared
    @State private var languageManager = LanguageManager.shared

    var body: some View {
        TabView {
            PrayerTimesHomeView()
                .tabItem {
                    Label(L10n.prayerTimes, systemImage: "clock.fill")
                }

            QuranHomeView()
                .tabItem {
                    Label(L10n.quran, systemImage: "book.fill")
                }

            DoaaHomeView()
                .tabItem {
                    Label(L10n.doaa, systemImage: "hands.sparkles.fill")
                }

            SettingsView()
                .tabItem {
                    Label(L10n.settings, systemImage: "gearshape.fill")
                }
        }
        .tint(IslamicColors.primaryGreenFallback)
        .preferredColorScheme(settingsVM.isDarkMode ? .dark : nil)
        .environment(\.layoutDirection, languageManager.layoutDirection)
        .onAppear {
            LiveActivityManager.shared.updateFromAppGroup()
            // Retry after a short delay so Live Activity can show on Lock Screen / Dynamic Island
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                LiveActivityManager.shared.updateFromAppGroup()
            }
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                LiveActivityManager.shared.updateFromAppGroup()
            }
        }
    }
}

#Preview {
    ContentView()
}
