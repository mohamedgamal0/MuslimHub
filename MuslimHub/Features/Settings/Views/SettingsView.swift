import SwiftUI

struct SettingsView: View {
    @State private var settingsVM = SettingsViewModel.shared

    var body: some View {
        NavigationStack {
            List {
                appearanceSection
                languageSection
                notificationsSection
                doaaReminderSection
                aboutSection
            }
            .scrollIndicators(.hidden)
            .navigationTitle(L10n.settings)
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Appearance
    private var appearanceSection: some View {
        Section {
            Toggle(isOn: $settingsVM.isDarkMode) {
                Label {
                    Text(L10n.darkMode)
                        .font(AppTypography.englishBody)
                } icon: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(LinearGradient(
                                colors: [.indigo, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 28, height: 28)

                        Image(systemName: settingsVM.isDarkMode ? "moon.fill" : "sun.max.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                    }
                }
            }
            .tint(IslamicColors.primaryGreenFallback)
        } header: {
            Text(L10n.appearance)
                .font(AppTypography.englishSmall)
        }
    }

    // MARK: - Language
    private var languageSection: some View {
        Section {
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Label {
                    Text(L10n.language)
                        .font(AppTypography.englishBody)
                } icon: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 28, height: 28)

                        Image(systemName: "globe")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                    }
                }
            }
        } header: {
            Text(L10n.general)
                .font(AppTypography.englishSmall)
        }
    }

    // MARK: - Notifications
    private var notificationsSection: some View {
        Section {
            Toggle(isOn: $settingsVM.prayerNotificationsEnabled) {
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.prayerNotifications)
                            .font(AppTypography.englishBody)
                        Text(LanguageManager.shared.localized(
                            "Get notified at prayer times",
                            arabic: "احصل على إشعار عند أوقات الصلاة"
                        ))
                        .font(AppTypography.englishSmall)
                        .foregroundStyle(.secondary)
                    }
                } icon: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(AppGradients.islamicGreen)
                            .frame(width: 28, height: 28)

                        Image(systemName: "bell.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                    }
                }
            }
            .tint(IslamicColors.primaryGreenFallback)
        } header: {
            Text(L10n.notifications)
                .font(AppTypography.englishSmall)
        }
    }

    // MARK: - Doaa Reminders
    private var doaaReminderSection: some View {
        Section {
            Toggle(isOn: $settingsVM.doaaRemindersEnabled) {
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.doaaReminders)
                            .font(AppTypography.englishBody)
                        Text(LanguageManager.shared.localized(
                            "Daily morning & evening reminders",
                            arabic: "تذكير يومي بأذكار الصباح والمساء"
                        ))
                        .font(AppTypography.englishSmall)
                        .foregroundStyle(.secondary)
                    }
                } icon: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 28, height: 28)

                        Image(systemName: "hands.sparkles.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                    }
                }
            }
            .tint(IslamicColors.primaryGreenFallback)

            if settingsVM.doaaRemindersEnabled {
                DatePicker(
                    LanguageManager.shared.localized("Morning", arabic: "الصباح"),
                    selection: $settingsVM.morningReminderTime,
                    displayedComponents: .hourAndMinute
                )
                .font(AppTypography.englishBody)

                DatePicker(
                    LanguageManager.shared.localized("Evening", arabic: "المساء"),
                    selection: $settingsVM.eveningReminderTime,
                    displayedComponents: .hourAndMinute
                )
                .font(AppTypography.englishBody)
            }
        } header: {
            Text(L10n.doaaReminders)
                .font(AppTypography.englishSmall)
        }
    }

    // MARK: - About
    private var aboutSection: some View {
        Section {
            HStack {
                Label {
                    Text(L10n.version)
                        .font(AppTypography.englishBody)
                } icon: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(LinearGradient(
                                colors: [.gray, .gray.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 28, height: 28)

                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                    }
                }

                Spacer()

                Text("\(settingsVM.appVersion) (\(settingsVM.buildNumber))")
                    .font(AppTypography.englishCaption)
                    .foregroundStyle(.secondary)
            }
        } header: {
            Text(L10n.about)
                .font(AppTypography.englishSmall)
        } footer: {
            VStack(spacing: AppSpacing.sm) {
                IslamicDivider()
                    .padding(.top, AppSpacing.md)

                Text("MuslimHub")
                    .font(AppTypography.englishSubtitle)
                    .foregroundStyle(IslamicColors.primaryGreenFallback)

                Text("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
                    .font(.system(size: 16, design: .serif))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, AppSpacing.md)
        }
    }
}

#Preview {
    SettingsView()
}
