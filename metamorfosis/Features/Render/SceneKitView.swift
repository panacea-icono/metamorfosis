import SwiftUI
import SceneKit

struct SceneKitView: UIViewRepresentable {
    let renderer: SceneRenderer

    func makeUIView(context: Context) -> SCNView {
        let v = SCNView()
        v.scene = renderer.scene
        v.allowsCameraControl = true
        v.backgroundColor = .black
        return v
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        // no-op
    }
}
