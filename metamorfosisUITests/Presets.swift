import SwiftUI

struct MorphPreset {
    let name: String
    let noseDorsum: CGFloat
    let noseTip: CGFloat
    let lipUpperVolume: CGFloat
    let lipLowerVolume: CGFloat
    let wrinkleSmooth: CGFloat
}

let presets: [MorphPreset] = [
    .init(name: "Rinoplastia Clásica", noseDorsum: 0.6, noseTip: 0.5, lipUpperVolume: 0.0, lipLowerVolume: 0.0, wrinkleSmooth: 0.0),
    .init(name: "Labios Volumen", noseDorsum: 0, noseTip: 0, lipUpperVolume: 0.7, lipLowerVolume: 0.7, wrinkleSmooth: 0),
    .init(name: "Rejuvenecimiento", noseDorsum: 0, noseTip: 0, lipUpperVolume: 0.15, lipLowerVolume: 0.15, wrinkleSmooth: 1)
]
