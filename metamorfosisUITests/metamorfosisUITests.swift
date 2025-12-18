import XCTest

final class metamorfosisUITests: XCTestCase {
    @MainActor
    func testSlidersAndSceneView() throws {
        let app = XCUIApplication()
        app.launch()

        // Busca el slider y muévelo (usa el texto del label)
        let dorsoSlider = app.sliders["Dorso nasal"]
        XCTAssertTrue(dorsoSlider.exists, "Debe existir el slider de dorso nasal")
        dorsoSlider.adjust(toNormalizedSliderPosition: 0.7)

        let upperLipSlider = app.sliders["Volumen labio superior"]
        XCTAssertTrue(upperLipSlider.exists, "Debe existir el slider de labio superior")
        upperLipSlider.adjust(toNormalizedSliderPosition: 0.5)
        
        // Verifica que SceneView visible
        XCTAssertTrue(app.otherElements["Simulación Facial"].exists)
    }
}
