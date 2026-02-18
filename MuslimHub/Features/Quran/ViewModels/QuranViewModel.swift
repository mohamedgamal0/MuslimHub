import SwiftUI

@Observable
final class QuranViewModel {
    // MARK: - Properties
    var surahs: [SurahListItem] = []
    var currentDetail: SurahDetail?
    var searchText = ""
    var bookmarks: [QuranBookmark] = []
    var showBookmarks = false

    var isLoadingSurahs = false
    var isLoadingDetail = false
    var surahsError: String?
    var detailError: String?
    var highlightedAyahId: Int?

    private let network = NetworkService.shared
    private let audioService = AudioService.shared
    private var detailCache: [Int: SurahDetail] = [:]

    // MARK: - Computed
    var filteredSurahs: [SurahListItem] {
        guard !searchText.isEmpty else { return surahs }
        return surahs.filter { surah in
            surah.name.localizedCaseInsensitiveContains(searchText) ||
            surah.englishName.localizedCaseInsensitiveContains(searchText) ||
            surah.englishNameTranslation.localizedCaseInsensitiveContains(searchText) ||
            String(surah.number).contains(searchText)
        }
    }

    var isPlaying: Bool { audioService.isPlaying }
    var playbackProgress: Double { audioService.progress }
    var currentPlayingSurahId: Int? { audioService.currentSurahId }
    var currentPlayingAyahNumber: Int? { audioService.currentAyahNumber }

    // MARK: - Init
    init() {
        loadBookmarks()
    }

    // MARK: - Fetch Surah List (all 114)
    func fetchSurahs() async {
        guard surahs.isEmpty || surahsError != nil else { return }
        isLoadingSurahs = true
        surahsError = nil

        do {
            let response = try await network.fetch(QuranListResponse.self, from: QuranAPI.surahList)
            surahs = response.data
        } catch {
            surahsError = error.localizedDescription
        }

        isLoadingSurahs = false
    }

    func refreshSurahs() async {
        isLoadingSurahs = true
        surahsError = nil

        do {
            let response = try await network.fetch(QuranListResponse.self, from: QuranAPI.surahList)
            surahs = response.data
        } catch {
            surahsError = error.localizedDescription
        }

        isLoadingSurahs = false
    }

    // MARK: - Fetch Surah Detail
    func fetchSurahDetail(number: Int) async {
        if let cached = detailCache[number] {
            currentDetail = cached
            return
        }

        isLoadingDetail = true
        detailError = nil

        do {
            let response = try await network.fetch(
                QuranEditionsResponse.self,
                from: QuranAPI.surahDetail(number: number)
            )

            guard response.data.count >= 2 else {
                detailError = "Incomplete data received"
                isLoadingDetail = false
                return
            }

            let arabicEdition = response.data[0]
            let englishEdition = response.data[1]

            let ayahs = zip(arabicEdition.ayahs, englishEdition.ayahs).map { arabic, english in
                AyahDetail(
                    id: arabic.number,
                    globalNumber: arabic.number,
                    numberInSurah: arabic.numberInSurah,
                    textArabic: arabic.text,
                    textEnglish: english.text,
                    juz: arabic.juz,
                    page: arabic.page
                )
            }

            let detail = SurahDetail(
                number: arabicEdition.number,
                name: arabicEdition.name,
                englishName: arabicEdition.englishName,
                englishNameTranslation: arabicEdition.englishNameTranslation,
                revelationType: arabicEdition.revelationType,
                numberOfAyahs: arabicEdition.numberOfAyahs,
                ayahs: ayahs
            )

            detailCache[number] = detail
            currentDetail = detail
        } catch {
            detailError = error.localizedDescription
        }

        isLoadingDetail = false
    }

    func refreshSurahDetail(number: Int) async {
        detailCache.removeValue(forKey: number)
        await fetchSurahDetail(number: number)
    }

    // MARK: - Audio
    func playAyah(surahId: Int, ayah: AyahDetail) {
        audioService.playAyah(
            surahId: surahId,
            ayahNumberInSurah: ayah.numberInSurah,
            globalAyahNumber: ayah.globalNumber
        )
    }

    func playFirstAyah(surahId: Int) {
        guard let detail = currentDetail, let first = detail.ayahs.first else { return }
        playAyah(surahId: surahId, ayah: first)
    }

    func togglePlayPause() {
        audioService.togglePlayPause()
    }

    func stopAudio() {
        audioService.stop()
    }

    // MARK: - Highlight
    func highlightAyah(_ ayahId: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            highlightedAyahId = ayahId
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            withAnimation(.easeOut(duration: 0.5)) {
                if self?.highlightedAyahId == ayahId {
                    self?.highlightedAyahId = nil
                }
            }
        }
    }

    // MARK: - Bookmarks
    func toggleBookmark(surahNumber: Int, surahName: String, ayah: AyahDetail) {
        if let index = bookmarks.firstIndex(where: { $0.surahId == surahNumber && $0.ayahNumber == ayah.numberInSurah }) {
            bookmarks.remove(at: index)
        } else {
            let bookmark = QuranBookmark(
                surahId: surahNumber,
                surahName: surahName,
                ayahNumber: ayah.numberInSurah,
                ayahText: ayah.textArabic
            )
            bookmarks.append(bookmark)
        }
        saveBookmarks()
    }

    func isBookmarked(surahId: Int, ayahNumber: Int) -> Bool {
        bookmarks.contains { $0.surahId == surahId && $0.ayahNumber == ayahNumber }
    }

    private func saveBookmarks() {
        if let data = try? JSONEncoder().encode(bookmarks) {
            UserDefaults.standard.set(data, forKey: "quran_bookmarks")
        }
    }

    private func loadBookmarks() {
        if let data = UserDefaults.standard.data(forKey: "quran_bookmarks"),
           let saved = try? JSONDecoder().decode([QuranBookmark].self, from: data) {
            bookmarks = saved
        }
    }
}
