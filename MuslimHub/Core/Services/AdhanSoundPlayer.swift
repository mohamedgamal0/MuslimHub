import AVFoundation
import Foundation

/// Plays `adhanNotification.mp3` (or .caf/.wav) from the app bundle when a prayer notification is received.
/// iOS cannot use MP3 as the system notification sound, so we play it in-app instead.
final class AdhanSoundPlayer: NSObject {
    static let shared = AdhanSoundPlayer()

    private var player: AVAudioPlayer?

    private override init() {
        super.init()
    }

    /// Call when a prayer notification is received (foreground or user tapped). Plays adhan if `adhanNotification.mp3` (or .caf/.wav) is in the bundle.
    func playIfAvailable() {
        DispatchQueue.main.async { [weak self] in
            self?.playIfAvailableOnMain()
        }
    }

    /// Call from UI (e.g. Settings "Play Adhan now") to test playback. Runs on current thread; call from main.
    func playNow() {
        if Thread.isMainThread {
            playIfAvailableOnMain()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.playIfAvailableOnMain()
            }
        }
    }

    private func playIfAvailableOnMain() {
        guard let url = urlForAdhanInBundle() else { return }
        play(url: url)
    }

    private func urlForAdhanInBundle() -> URL? {
        let candidates: [(base: String, ext: String)] = [
            ("adhanNotification", "mp3"),
            ("adhanNotification", "caf"),
            ("adhanNotification", "wav"),
            ("adhanNotification", "aiff"),
        ]
        for (base, ext) in candidates {
            if let url = Bundle.main.url(forResource: base, withExtension: ext) {
                return url
            }
        }
        return nil
    }

    private func play(url: URL) {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            // Session may already be set by another part of the app (e.g. Quran); still try to play
        }

        player?.stop()
        player = nil

        guard let newPlayer = try? AVAudioPlayer(contentsOf: url) else { return }
        newPlayer.delegate = self
        newPlayer.prepareToPlay()
        player = newPlayer
        newPlayer.play()
    }
}

extension AdhanSoundPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player = nil
    }
}
