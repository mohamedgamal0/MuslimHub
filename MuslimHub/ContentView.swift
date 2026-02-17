import SwiftUI

struct ContentView: View {
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
    }
}

#Preview {
    ContentView()
}
