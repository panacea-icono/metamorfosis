import SwiftUI

struct ContentView: View {
    @State private var vm: SimulationViewModel?
    @State private var renderer = SceneRenderer()
    @State private var errorText: String?

    var body: some View {
        Group {
            if let vm {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(vm.procedure.name).font(.headline)

                        if let preset = vm.procedure.presets.first {
                            Button("Aplicar preset: \(preset.name)") {
                                vm.applyPreset(preset)
                                renderer.applyMorphWeights(vm.weights)
                            }
                        }

                        Divider()

                        ForEach(vm.procedure.sliders) { s in
                            VStack(alignment: .leading) {
                                Text(s.name).font(.subheadline)
                                Slider(
                                    value: Binding(
                                        get: { vm.weights[s.id] ?? s.default },
                                        set: { newVal in
                                            vm.setWeight(id: s.id, value: newVal)
                                            renderer.applyMorphWeights(vm.weights)
                                        }
                                    ),
                                    in: s.min...s.max
                                )
                            }
                        }

                        Spacer()
                    }
                    .frame(maxWidth: 360)
                    .padding()

                    SceneKitView(renderer: renderer)
                        .ignoresSafeArea()
                }
            } else if let errorText {
                Text(errorText).padding()
            } else {
                ProgressView().task {
                    do {
                        let presets = try PresetsLoader.loadPresets()
                        guard let first = presets.procedures.first else { throw NSError(domain: "ContentView", code: 2, userInfo: [NSLocalizedDescriptionKey:"No procedures in presets.json"]) }
                        vm = SimulationViewModel(procedure: first)

                        // Opcional: carga un modelo si lo agregas al bundle (por ejemplo: Models/base.scn)
                        if let url = Bundle.main.url(forResource: "base", withExtension: "scn", subdirectory: "Models") {
                            renderer.loadModel(from: url)
                        }
                    } catch {
                        errorText = String(describing: error)
                    }
                }
            }
        }
    }
}
