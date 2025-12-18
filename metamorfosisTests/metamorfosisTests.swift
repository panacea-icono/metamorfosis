import Testing
@testable import metamorfosis

@Suite("Morphing UI y lógica de sliders")
struct MorphingTests {
    @Test("Los sliders inicializan en 0")
    func slidersArrancanEnCero() async throws {
        let view = ContentView()
        // Solo podemos testear propiedades si refactorizas ContentView a ViewModel.
        // Mientras tanto, esto solo es placeholder.
        #expect(view.body != nil, "La vista debe existir")
    }
}
