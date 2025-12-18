import Foundation
import Observation

@Observable
final class SimulationViewModel {
    var procedure: ProcedureSpec
    var weights: [String: Double]

    init(procedure: ProcedureSpec) {
        self.procedure = procedure
        self.weights = Dictionary(uniqueKeysWithValues: procedure.sliders.map { ($0.id, $0.default) })
    }

    func applyPreset(_ preset: ProcedurePreset) {
        for (k,v) in preset.weights { weights[k] = v }
    }

    func setWeight(id: String, value: Double) {
        weights[id] = value
    }
}
