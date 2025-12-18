import Foundation
import SceneKit

final class SceneRenderer {
    let scene = SCNScene()
    let cameraNode: SCNNode = {
        let n = SCNNode()
        let cam = SCNCamera()
        cam.zNear = 0.01
        cam.zFar = 200.0
        n.camera = cam
        n.position = SCNVector3(0, 0, 3)
        return n
    }()

    private(set) var modelNode: SCNNode?

    init() {
        scene.rootNode.addChildNode(cameraNode)

        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(2, 2, 5)
        scene.rootNode.addChildNode(lightNode)

        let ambient = SCNLight()
        ambient.type = .ambient
        ambient.intensity = 300
        let ambientNode = SCNNode()
        ambientNode.light = ambient
        scene.rootNode.addChildNode(ambientNode)
    }

    func loadModel(from url: URL) {
        let loaded = try? SCNScene(url: url, options: nil)
        let node = loaded?.rootNode.clone() ?? SCNNode()
        node.name = "model"
        scene.rootNode.addChildNode(node)
        modelNode = node
    }

    /// Aplica pesos a SCNMorpher si existe en el nodo principal.
    func applyMorphWeights(_ weights: [String: Double]) {
        guard let node = modelNode else { return }
        // Busca un nodo con geometry + morpher
        let targetNode = node.childNodes.first(where: { $0.morpher != nil }) ?? node
        guard let morpher = targetNode.morpher else { return }

        // Match por nombre de target (si tus targets llevan names estables)
        for i in 0..<morpher.targets.count {
            let target = morpher.targets[i]
            let key = target.name ?? "target_\(i)"
            let w = weights[key] ?? 0.0
            morpher.setWeight(CGFloat(w), forTargetAt: i)
        }
    }
}
