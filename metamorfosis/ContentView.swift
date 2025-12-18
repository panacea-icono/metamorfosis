import SwiftUI
import SceneKit
import UIKit
import PDFKit

struct ContentView: View {
    @State private var noseDorsum: CGFloat = 0
    @State private var noseTip: CGFloat = 0
    @State private var lipUpperVolume: CGFloat = 0
    @State private var lipLowerVolume: CGFloat = 0
    @State private var wrinkleSmooth: CGFloat = 0

    @State private var beforeImage: UIImage?
    @State private var afterImage: UIImage?
    @State private var showShareSheet = false
    @State private var pdfURL: URL?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SceneViewContainer(
                    noseDorsum: noseDorsum,
                    noseTip: noseTip,
                    lipUpperVolume: lipUpperVolume,
                    lipLowerVolume: lipLowerVolume,
                    wrinkleSmooth: wrinkleSmooth
                )
                .frame(height: 400)
                .cornerRadius(16)
                .padding(.top, 16)

                HStack {
                    Button("Capturar ANTES") {
                        captureImage(isBefore: true)
                    }
                    .buttonStyle(.bordered)
                    Button("Capturar DESPUÉS") {
                        captureImage(isBefore: false)
                    }
                    .buttonStyle(.bordered)
                }
                .padding()

                if beforeImage != nil && afterImage != nil {
                    Button("Exportar PDF Comparativo") {
                        exportPDF()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom)
                }

                Form {
                    Section(header: Text("Rinoplastia")) {
                        Slider(value: $noseDorsum, in: 0...1, label: { Text("Dorso nasal") })
                        Slider(value: $noseTip, in: 0...1, label: { Text("Punta nasal") })
                    }
                    Section(header: Text("Labios")) {
                        Slider(value: $lipUpperVolume, in: 0...1, label: { Text("Volumen labio superior") })
                        Slider(value: $lipLowerVolume, in: 0...1, label: { Text("Volumen labio inferior") })
                    }
                    Section(header: Text("Arrugas")) {
                        Slider(value: $wrinkleSmooth, in: 0...1, label: { Text("Suavizado arrugas") })
                    }
                }
                .padding(.top, 10)

                Spacer()
            }
            .navigationTitle("Simulación Facial")
            .sheet(isPresented: $showShareSheet, content: {
                if let url = pdfURL {
                    ShareSheet(activityItems: [url])
                }
            })
        }
    }

    // MARK: - Captura imágenes (antes/después)
    private func captureImage(isBefore: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let image = window.snapshot()
            if isBefore {
                beforeImage = image
            } else {
                afterImage = image
            }
        }
    }

    // MARK: - Exportar PDF
    private func exportPDF() {
        guard let before = beforeImage, let after = afterImage else { return }
        if let url = exportImagesToPDF(images: [before, after], fileName: "Comparativo") {
            pdfURL = url
            showShareSheet = true
        }
    }
}

// MARK: - SceneKit
struct SceneViewContainer: UIViewRepresentable {
    var noseDorsum: CGFloat
    var noseTip: CGFloat
    var lipUpperVolume: CGFloat
    var lipLowerVolume: CGFloat
    var wrinkleSmooth: CGFloat

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        if let scene = SCNScene(named: "model.glb") {
            if let node = scene.rootNode.childNodes.first,
               let morpher = node.morpher {
                morpher.setWeight(noseDorsum, forTargetAt: 0)
                morpher.setWeight(noseTip, forTargetAt: 1)
                morpher.setWeight(lipUpperVolume, forTargetAt: 2)
                morpher.setWeight(lipLowerVolume, forTargetAt: 3)
                morpher.setWeight(wrinkleSmooth, forTargetAt: 4)
            }
            scnView.scene = scene
        }
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = .systemBackground
        return scnView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        if let node = scnView.scene?.rootNode.childNodes.first,
           let morpher = node.morpher {
            morpher.setWeight(noseDorsum, forTargetAt: 0)
            morpher.setWeight(noseTip, forTargetAt: 1)
            morpher.setWeight(lipUpperVolume, forTargetAt: 2)
            morpher.setWeight(lipLowerVolume, forTargetAt: 3)
            morpher.setWeight(wrinkleSmooth, forTargetAt: 4)
        }
    }
}

// MARK: - Utilidades

extension UIView {
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { ctx in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - PDF Export

func exportImagesToPDF(images: [UIImage], fileName: String) -> URL? {
    let pdfDocument = PDFDocument()
    for (index, image) in images.enumerated() {
        if let pdfPage = PDFPage(image: image) {
            pdfDocument.insert(pdfPage, at: index)
        }
    }
    let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).pdf")
    pdfDocument.write(to: fileURL)
    return fileURL
}
