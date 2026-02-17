import Foundation
import AVFoundation

@Observable
final class AudioService {
    static let shared = AudioService()

    var isPlaying = false
    var currentSurahId: Int?
    var currentAyahNumber: Int?
    var progress: Double = 0
    var duration: Double = 0
    var isLoading = false

    private var player: AVPlayer?
    private var timeObserver: Any?

    private init() {
        configureAudioSession()
    }

    // MARK: - Audio Session
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }

    // MARK: - Playback Control
    func playAyah(surahId: Int, ayahNumberInSurah: Int, globalAyahNumber: Int) {
        let urlString = QuranAPI.audioURL(globalAyahNumber: globalAyahNumber)
        guard let url = URL(string: urlString) else { return }

        stop()
        isLoading = true
        currentSurahId = surahId
        currentAyahNumber = ayahNumberInSurah

        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        addTimeObserver()

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            self?.isPlaying = false
            self?.progress = 0
        }

        player?.play()
        isPlaying = true
        isLoading = false
    }

    func togglePlayPause() {
        guard let player else { return }

        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }

    func stop() {
        removeTimeObserver()
        player?.pause()
        player = nil
        isPlaying = false
        progress = 0
        duration = 0
        currentSurahId = nil
        currentAyahNumber = nil
    }

    func seek(to percentage: Double) {
        guard let player, let item = player.currentItem else { return }
        let totalSeconds = item.duration.seconds
        guard totalSeconds.isFinite else { return }
        let targetTime = CMTime(seconds: totalSeconds * percentage, preferredTimescale: 600)
        player.seek(to: targetTime)
    }

    // MARK: - Time Observer
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self,
                  let item = self.player?.currentItem,
                  item.duration.seconds.isFinite else { return }

            self.progress = time.seconds / item.duration.seconds
            self.duration = item.duration.seconds
        }
    }

    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
}
