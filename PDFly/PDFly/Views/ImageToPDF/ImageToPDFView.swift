//
//  ImageToPDFView.swift
//  PDFly
//
//  Created by Jaymeen Unadkat on 21/02/25.
//

import SwiftUI
import PhotosUI
import PDFKit

struct ImageToPDFView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []
    @State private var pdfURL: URL?
    @State private var showPDFSheet = false
    @State private var showShareSheet = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                PhotosPicker("Select Images", selection: $selectedItems, maxSelectionCount: 10, matching: .images)
                    .onChange(of: selectedItems) { _, _ in
                        loadImages()
                    }

                if !images.isEmpty {
                    Button("Create PDF") {
                        createPDF()
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.green)
                }
            }
            .padding()
            .sheet(isPresented: $showPDFSheet, onDismiss: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    showShareSheet = true
                })
            }, content: {
                PDFShareSheet(pdfURL: $pdfURL)
            })
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(url: $pdfURL)
            }
        }
    }

    private func loadImages() {
        images.removeAll()
        for item in selectedItems {
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        images.append(image)
                        print("Image - \(image)")
                    }
                case .failure(let error):
                    print("Failed to load image: \(error)")
                }
            }
        }
    }

    private func createPDF() {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))

        do {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("GeneratedImages.pdf")
            try pdfRenderer.writePDF(to: tempURL, withActions: { context in
                for image in images {
                    context.beginPage()
                    let aspectRatio = image.size.width / image.size.height
                    let targetWidth: CGFloat = 500
                    let targetHeight = targetWidth / aspectRatio
                    let rect = CGRect(x: (612 - targetWidth) / 2, y: (792 - targetHeight) / 2, width: targetWidth, height: targetHeight)
                    image.draw(in: rect)
                }
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                pdfURL = tempURL
                showPDFSheet = true
            })
        } catch {
            print("Failed to create PDF: \(error)")
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    @Binding var url: URL?
    var activityItems: [Any] {
        if let url = url {
            return [url]
        } else {
            return []
        }
    }
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
