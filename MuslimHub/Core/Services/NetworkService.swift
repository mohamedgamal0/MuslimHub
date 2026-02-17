import Foundation

// MARK: - Network Errors
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse(Int)
    case decodingFailed(Error)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse(let code):
            return "Server error (HTTP \(code))"
        case .decodingFailed(let error):
            return "Data parsing failed: \(error.localizedDescription)"
        case .noData:
            return "No data received"
        }
    }
}

// MARK: - Network Service
final class NetworkService {
    static let shared = NetworkService()

    private let session: URLSession
    private let decoder: JSONDecoder

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 120
        config.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: config)
        decoder = JSONDecoder()
    }

    func fetch<T: Decodable>(_ type: T.Type, from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw NetworkError.requestFailed(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(0)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }

    func fetchData(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse(0)
        }

        return data
    }
}

// MARK: - Quran API Endpoints
enum QuranAPI {
    static let baseURL = "https://api.alquran.cloud/v1"

    static var surahList: String { "\(baseURL)/surah" }

    static func surahDetail(number: Int) -> String {
        "\(baseURL)/surah/\(number)/editions/quran-uthmani,en.sahih"
    }

    static func audioURL(globalAyahNumber: Int) -> String {
        "https://cdn.islamic.network/quran/audio/128/ar.alafasy/\(globalAyahNumber).mp3"
    }
}

// MARK: - Hadith API Endpoints
enum HadithAPI {
    static let baseURL = "https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1"

    static func editionInfo(name: String) -> String {
        "\(baseURL)/editions/\(name)/info.json"
    }

    static func editionSection(name: String, section: Int) -> String {
        "\(baseURL)/editions/\(name)/\(section).json"
    }

    static func fullEdition(name: String) -> String {
        "\(baseURL)/editions/\(name).min.json"
    }
}
