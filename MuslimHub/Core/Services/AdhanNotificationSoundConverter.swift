import AVFoundation
import Foundation

/// Converts adhanNotification.mp3 to adhanNotification.caf (Linear PCM) and saves to Library/Sounds
/// so the system can play it when the notification is delivered (app in background).
enum AdhanNotificationSoundConverter {
    private static let maxDurationSeconds: Double = 30
    private static let outputFileName = "adhanNotification.caf"

    /// URL for the converted file in Library/Sounds (system looks here for notification sounds).
    static var librarySoundsURL: URL? {
        FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?
            .appendingPathComponent("Sounds", isDirectory: true)
    }

    static func convertedCafURL() -> URL? {
        librarySoundsURL?.appendingPathComponent(outputFileName)
    }

    /// If bundle has .caf/.wav/.aiff, returns that. If bundle has only .mp3, converts to CAF and saves to Library/Sounds.
    /// Returns the filename to use with UNNotificationSound(named:) so the system plays it when the notification arrives.
    static func prepareNotificationSound() -> String? {
        if Bundle.main.url(forResource: "adhanNotification", withExtension: "caf") != nil {
            return outputFileName
        }
        if Bundle.main.url(forResource: "adhanNotification", withExtension: "wav") != nil {
            return "adhanNotification.wav"
        }
        if Bundle.main.url(forResource: "adhanNotification", withExtension: "aiff") != nil {
            return "adhanNotification.aiff"
        }
        guard let mp3URL = Bundle.main.url(forResource: "adhanNotification", withExtension: "mp3") else {
            return nil
        }
        guard let soundsDir = librarySoundsURL else { return nil }
        let cafURL = soundsDir.appendingPathComponent(outputFileName)
        do {
            try FileManager.default.createDirectory(at: soundsDir, withIntermediateDirectories: true)
        } catch {
            return nil
        }
        if convertMP3ToCAF(source: mp3URL, destination: cafURL) {
            return outputFileName
        }
        return nil
    }

    private static func convertMP3ToCAF(source: URL, destination: URL) -> Bool {
        guard let srcFile = try? AVAudioFile(forReading: source) else { return false }
        let srcFormat = srcFile.processingFormat
        guard let dstFormat = AVAudioFormat(
            commonFormat: .pcmFormatInt16,
            sampleRate: 44100,
            channels: 1,
            interleaved: true
        ) else { return false }
        guard let converter = AVAudioConverter(from: srcFormat, to: dstFormat) else { return false }

        let maxSrcFrames = AVAudioFrameCount(min(Double(srcFile.length), maxDurationSeconds * srcFormat.sampleRate))
        guard let dstFile = try? AVAudioFile(
            forWriting: destination,
            settings: dstFormat.settings,
            commonFormat: .pcmFormatInt16,
            interleaved: true
        ) else { return false }

        let bufferSize: AVAudioFrameCount = 4096
        guard let srcBuffer = AVAudioPCMBuffer(pcmFormat: srcFormat, frameCapacity: bufferSize) else { return false }
        guard let dstBuffer = AVAudioPCMBuffer(pcmFormat: dstFormat, frameCapacity: bufferSize) else { return false }

        srcFile.framePosition = 0
        let inputBlock: AVAudioConverterInputBlock = { _, outStatus in
            if srcFile.framePosition >= maxSrcFrames {
                outStatus.pointee = .endOfStream
                return nil
            }
            do {
                try srcFile.read(into: srcBuffer)
                if srcBuffer.frameLength == 0 {
                    outStatus.pointee = .endOfStream
                    return nil
                }
                outStatus.pointee = .haveData
                return srcBuffer
            } catch {
                outStatus.pointee = .endOfStream
                return nil
            }
        }

        var totalWritten: AVAudioFramePosition = 0
        while true {
            var error: NSError?
            let status = converter.convert(to: dstBuffer, error: &error, withInputFrom: inputBlock)
            if let error = error { break }
            if status == .error { break }
            if dstBuffer.frameLength == 0 { break }
            do {
                try dstFile.write(from: dstBuffer)
                totalWritten += AVAudioFramePosition(dstBuffer.frameLength)
            } catch {
                return false
            }
            if status == .endOfStream { break }
        }
        return totalWritten > 0
    }
}
