import PDFKit

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
