import Foundation
import CryptoKit

// MARK: - JSON structures for adhkar.json
private struct AdhkarSection: Codable {
    let id: Int
    let category: String
    let array: [AdhkarItem]
}

private struct AdhkarItem: Codable {
    let id: Int
    let text: String
    let count: Int
}

// MARK: - muslimKit JSON format (https://ahegazy.github.io/muslimKit/json/)
private struct MuslimKitAzkar: Codable {
    let title: String
    let content: [MuslimKitZekr]
}

private struct MuslimKitZekr: Codable {
    let zekr: String
    let repeatCount: Int
    let bless: String

    enum CodingKeys: String, CodingKey {
        case zekr, bless
        case repeatCount = "repeat"
    }
}

// MARK: - Loader
enum AdhkarLoader {
    static func loadFromBundle() -> [Doaa] {
        var all: [Doaa] = []
        // Local adhkar.json (Hisnul Muslim format)
        if let url = Bundle.main.url(forResource: "adhkar", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            all.append(contentsOf: parseHisnulMuslim(data))
        }
        // muslimKit azkar (azkar_sabah, azkar_massa, PostPrayer_azkar)
        all.append(contentsOf: loadMuslimKitAzkar())
        return all
    }

    private static func loadMuslimKitAzkar() -> [Doaa] {
        var result: [Doaa] = []
        let files: [(String, DoaaCategory)] = [
            ("azkar_sabah", .morning),
            ("azkar_massa", .evening),
            ("PostPrayer_azkar", .postPrayer)
        ]
        for (name, category) in files {
            guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
                  let data = try? Data(contentsOf: url),
                  let azkar = try? JSONDecoder().decode(MuslimKitAzkar.self, from: data) else { continue }
            for (index, item) in azkar.content.enumerated() {
                let id = deterministicUUID(prefix: "muslimkit-\(name)", itemId: index)
                let source = item.bless.isEmpty ? "muslimKit" : item.bless
                let doaa = Doaa(
                    textArabic: item.zekr.trimmingCharacters(in: .whitespacesAndNewlines),
                    textEnglish: "",
                    transliteration: "",
                    category: category,
                    source: source,
                    repeatCount: max(1, item.repeatCount),
                    id: id
                )
                result.append(doaa)
            }
        }
        return result
    }

    private static func parseHisnulMuslim(_ data: Data) -> [Doaa] {
        let decoder = JSONDecoder()
        guard let sections = try? decoder.decode([AdhkarSection].self, from: data) else {
            return []
        }
        var result: [Doaa] = []
        for section in sections {
            let category = mapCategory(section.category)
            for item in section.array {
                let id = deterministicUUID(sectionId: section.id, itemId: item.id)
                let doaa = Doaa(
                    textArabic: cleanArabic(item.text),
                    textEnglish: "",
                    transliteration: "",
                    category: category,
                    source: "Hisnul Muslim",
                    repeatCount: max(1, item.count),
                    id: id
                )
                result.append(doaa)
            }
        }
        return result
    }

    private static func cleanArabic(_ text: String) -> String {
        var s = text
            .replacingOccurrences(of: "(( ", with: "")
            .replacingOccurrences(of: "))", with: "")
            .replacingOccurrences(of: ")).", with: ".")
            .replacingOccurrences(of: "﴾", with: "")
            .replacingOccurrences(of: "﴿", with: "")
        if s.hasPrefix("((") { s = String(s.dropFirst(2)) }
        return s.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func mapCategory(_ arabicCategory: String) -> DoaaCategory {
        let c = arabicCategory
        if c.contains("الصباح") && c.contains("المساء") { return .morning }
        if c.contains("أذكار الصباح") { return .morning }
        if c.contains("أذكار المساء") { return .evening }
        if c.contains("النوم") || c.contains("تقلب ليلا") || c.contains("الفزع في النوم") { return .sleep }
        if c.contains("الاستيقاظ من النوم") { return .sleep }
        if c.contains("الطعام") || c.contains("إفطار الصائم") || c.contains("الفراغ من الطعام") || c.contains("قبل الطعام") { return .food }
        if c.contains("السفر") || c.contains("الركوب") || c.contains("دخول القرية") || c.contains("دخول السوق") || c.contains("المسافر") || c.contains("المقيم") || c.contains("سير السفر") { return .travel }
        if c.contains("المريض") || c.contains("الشفاء") || c.contains("عيادة") || c.contains("وجعا في جسده") { return .health }
        if c.contains("الدجال") || c.contains("كَلِمَاتِ اللَّهِ التَّامَّاتِ") { return .protection }
        return .general
    }

    private static func deterministicUUID(sectionId: Int, itemId: Int) -> UUID {
        deterministicUUID(prefix: "adhkar-\(sectionId)", itemId: itemId)
    }

    private static func deterministicUUID(prefix: String, itemId: Int) -> UUID {
        let string = "\(prefix)-\(itemId)"
        let data = Data(string.utf8)
        let hash = SHA256.hash(data: data)
        let hex = hash.map { String(format: "%02x", $0) }.joined()
        let hexPrefix = String(hex.prefix(32))
        let uuidString = "\(hexPrefix.prefix(8))-\(hexPrefix.dropFirst(8).prefix(4))-4\(hexPrefix.dropFirst(13).prefix(3))-\(hexPrefix.dropFirst(16).prefix(4))-\(hexPrefix.dropFirst(20).prefix(12))"
        return UUID(uuidString: uuidString) ?? UUID()
    }
}
