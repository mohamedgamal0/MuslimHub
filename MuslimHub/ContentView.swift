import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .prayerTimes
    @State private var settingsVM = SettingsViewModel.shared
    @State private var languageManager = LanguageManager.shared

    enum Tab: String, CaseIterable {
        case prayerTimes, quran, hadith, doaa, settings

        var icon: String {
            switch self {
            case .quran: return "book.fill"
            case .hadith: return "text.book.closed.fill"
            case .doaa: return "hands.sparkles.fill"
            case .prayerTimes: return "clock.fill"
            case .settings: return "gearshape.fill"
            }
        }

        var label: String {
            switch self {
            case .quran: return L10n.quran
            case .hadith: return L10n.hadith
            case .doaa: return L10n.doaa
            case .prayerTimes: return L10n.prayerTimes
            case .settings: return L10n.settings
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                PrayerTimesHomeView()
                    .tag(Tab.prayerTimes)
                    .toolbarVisibility(.hidden, for: .tabBar)

                QuranHomeView()
                    .tag(Tab.quran)
                    .toolbarVisibility(.hidden, for: .tabBar)

                HadithHomeView()
                    .tag(Tab.hadith)
                    .toolbarVisibility(.hidden, for: .tabBar)

                DoaaHomeView()
                    .tag(Tab.doaa)
                    .toolbarVisibility(.hidden, for: .tabBar)

                SettingsView()
                    .tag(Tab.settings)
                    .toolbarVisibility(.hidden, for: .tabBar)
            }

            customTabBar
        }
        .preferredColorScheme(settingsVM.isDarkMode ? .dark : nil)
        .environment(\.layoutDirection, languageManager.layoutDirection)
    }

    // MARK: - Custom Tab Bar
    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach([Tab.prayerTimes, .quran, .hadith, .doaa, .settings], id: \.rawValue) { tab in
                tabButton(tab)
            }
        }
        .padding(.horizontal, AppSpacing.xs)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.sm + 20)
        .background(
            UnevenRoundedRectangle(
                topLeadingRadius: AppCornerRadius.extraLarge,
                topTrailingRadius: AppCornerRadius.extraLarge
            )
            .fill(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.08), radius: 20, y: -5)
            .ignoresSafeArea(edges: .bottom)
        )
    }

    private func tabButton(_ tab: Tab) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    if selectedTab == tab {
                        Capsule()
                            .fill(IslamicColors.primaryGreenFallback.opacity(0.12))
                            .frame(width: 48, height: 30)
                            .matchedGeometryEffect(id: "tabIndicator", in: tabNamespace)
                    }

                    Image(systemName: tab.icon)
                        .font(.system(size: 16, weight: selectedTab == tab ? .bold : .regular))
                        .foregroundStyle(selectedTab == tab
                                         ? IslamicColors.primaryGreenFallback
                                         : .secondary)
                        .symbolEffect(.bounce, value: selectedTab == tab)
                }
                .frame(height: 30)

                Text(tab.label)
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundStyle(selectedTab == tab
                                     ? IslamicColors.primaryGreenFallback
                                     : .secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    @Namespace private var tabNamespace
}

#Preview {
    ContentView()
}
