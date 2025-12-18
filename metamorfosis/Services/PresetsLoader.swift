import Foundation

enum PresetsLoader {
    static func loadPresets() throws -> PresetsFile {
        let url = Bundle.main.url(forResource: "presets", withExtension: "json", subdirectory: "Presets")
        guard let url else { throw NSError(domain: "PresetsLoader", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing Presets/presets.json in app bundle"]) }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(PresetsFile.self, from: data)
    }
}
