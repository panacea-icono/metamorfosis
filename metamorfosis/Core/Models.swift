import Foundation

public struct SliderSpec: Codable, Hashable, Identifiable {
    public var id: String
    public var name: String
    public var min: Double
    public var max: Double
    public var `default`: Double
}

public struct ProcedurePreset: Codable, Hashable, Identifiable {
    public var id: String
    public var name: String
    public var weights: [String: Double]
}

public struct ProcedureSpec: Codable, Hashable, Identifiable {
    public var id: String
    public var name: String
    public var sliders: [SliderSpec]
    public var presets: [ProcedurePreset]
}

public struct PresetsFile: Codable, Hashable {
    public var version: Int
    public var procedures: [ProcedureSpec]
}
