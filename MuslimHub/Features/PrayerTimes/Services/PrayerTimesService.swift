import Foundation
import CoreLocation

// MARK: - Calculation Method (Aladhan API method IDs)
/// Configurable calculation method for prayer times. See https://aladhan.com/prayer-times-api
enum AladhanCalculationMethod: Int, CaseIterable, Identifiable {
    case muslimWorldLeague = 3
    case egyptian = 5
    case ummAlQura = 4
    case isna = 2
    case gulf = 8
    case kuwait = 9
    case qatar = 10
    case singapore = 11
    case turkey = 13
    case tehran = 7

    var id: Int { rawValue }

    var displayName: String {
        switch self {
        case .muslimWorldLeague: return "Muslim World League"
        case .egyptian: return "Egyptian General Authority"
        case .ummAlQura: return "Umm Al-Qura, Makkah"
        case .isna: return "Islamic Society of North America"
        case .gulf: return "Gulf Region"
        case .kuwait: return "Kuwait"
        case .qatar: return "Qatar"
        case .singapore: return "Singapore"
        case .turkey: return "Turkey"
        case .tehran: return "Tehran"
        }
    }
}

// MARK: - Service Errors
enum PrayerTimesServiceError: Error, LocalizedError {
    case invalidURL
    case networkFailure(Error)
    case invalidResponse(statusCode: Int)
    case decodingFailure(Error)
    case noTimingsInResponse
    case invalidTimingFormat(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL"
        case .networkFailure(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse(let code):
            return "Server returned an error (HTTP \(code))"
        case .decodingFailure(let error):
            return "Could not read prayer times: \(error.localizedDescription)"
        case .noTimingsInResponse:
            return "No prayer times in API response"
        case .invalidTimingFormat(let field):
            return "Invalid time format for \(field)"
        }
    }
}

// MARK: - Result Model
/// Production-ready result of a prayer times fetch: exact times for the six prayers + sunrise.
struct PrayerTimesResult {
    let date: Date
    let timings: [PrayerTimeEntry]
    let timezone: TimeZone
    let method: AladhanCalculationMethod
    let apiDateReadable: String?

    /// Exact prayer times in order: Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha
    var fajr: Date? { timings.first(where: { $0.prayer == .fajr })?.time }
    var sunrise: Date? { timings.first(where: { $0.prayer == .sunrise })?.time }
    var dhuhr: Date? { timings.first(where: { $0.prayer == .dhuhr })?.time }
    var asr: Date? { timings.first(where: { $0.prayer == .asr })?.time }
    var maghrib: Date? { timings.first(where: { $0.prayer == .maghrib })?.time }
    var isha: Date? { timings.first(where: { $0.prayer == .isha })?.time }
}

// MARK: - Prayer Times Service
/// Dynamic prayer time service using the Aladhan Prayer Times API.
/// Builds requests from: latitude, longitude, current date, and configurable calculation method.
final class PrayerTimesService {
    static let shared = PrayerTimesService()

    private let baseURL = "https://api.aladhan.com/v1/timings"
    private let session: URLSession
    private let decoder: JSONDecoder

    private init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    /// Fetches prayer times for the given date and location using the specified method.
    /// - Parameters:
    ///   - date: The date for which to get times (default: today).
    ///   - latitude: User latitude.
    ///   - longitude: User longitude.
    ///   - method: Calculation method (default: Umm Al-Qura).
    ///   - timezone: Timezone for the returned times (default: device timezone).
    /// - Returns: A result containing Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha as `Date` values and as `[PrayerTimeEntry]`.
    func fetchPrayerTimes(
        date: Date = Date(),
        latitude: Double,
        longitude: Double,
        method: AladhanCalculationMethod = .ummAlQura,
        timezone: TimeZone = .current
    ) async throws -> PrayerTimesResult {
        let url = try buildRequestURL(
            date: date,
            latitude: latitude,
            longitude: longitude,
            method: method,
            timezone: timezone
        )

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw PrayerTimesServiceError.networkFailure(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw PrayerTimesServiceError.invalidResponse(statusCode: 0)
        }
        guard (200...299).contains(http.statusCode) else {
            throw PrayerTimesServiceError.invalidResponse(statusCode: http.statusCode)
        }

        let apiResponse: AladhanTimingsResponse
        do {
            apiResponse = try decoder.decode(AladhanTimingsResponse.self, from: data)
        } catch {
            throw PrayerTimesServiceError.decodingFailure(error)
        }

        guard let timings = apiResponse.data?.timings else {
            throw PrayerTimesServiceError.noTimingsInResponse
        }

        let entries = timings.toPrayerTimeEntries(for: date)
        guard !entries.isEmpty else {
            throw PrayerTimesServiceError.noTimingsInResponse
        }

        let readable = apiResponse.data?.date?.readable
        return PrayerTimesResult(
            date: date,
            timings: entries,
            timezone: timezone,
            method: method,
            apiDateReadable: readable
        )
    }

    /// Builds the request URL dynamically: latitude, longitude, date (YYYY-MM-DD), method.
    private func buildRequestURL(
        date: Date,
        latitude: Double,
        longitude: Double,
        method: AladhanCalculationMethod,
        timezone: TimeZone
    ) throws -> URL {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = timezone
        let dateString = formatter.string(from: date)

        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "date", value: dateString),
            URLQueryItem(name: "method", value: String(method.rawValue)),
            URLQueryItem(name: "timezonestring", value: timezone.identifier)
        ]

        guard let url = components?.url else {
            throw PrayerTimesServiceError.invalidURL
        }
        return url
    }
}
