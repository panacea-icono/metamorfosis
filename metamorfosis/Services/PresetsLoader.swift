import Foundation

enum PresetsLoader {
    static func loadPresets() throws -> PresetsFile {
        // 1) Intenta Presets/presets.json (carpeta en bundle)
        // 2) Fallback a presets.json en la raíz del bundle (archivo suelto)
        let candidates: [URL?] = [
            Bundle.main.url(forResource: "presets", withExtension: "json", subdirectory: "Presets"),
            Bundle.main.url(forResource: "presets", withExtension: "json")
        ]

        guard let url = candidates.compactMap({ $0 }).first else {
            throw NSError(
                domain: "PresetsLoader",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Missing presets.json in app bundle (either Presets/ or root)."]
            )
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(PresetsFile.self, from: data)
    }
}
