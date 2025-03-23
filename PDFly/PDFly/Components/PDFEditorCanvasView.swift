//
//  PDFEditorCanvasView.swift
//  PDFly
//
//  Created by Jaymeen Unadkat on 21/02/25.
//

import SwiftUI
import PDFKit
import PencilKit

struct PDFEditorCanvasView: UIViewRepresentable {
    let pdfDocument: PDFDocument
    var selectedTool: EditorTool

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()

        // PDF View
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.translatesAutoresizingMaskIntoConstraints = false

        // Canvas View
        let canvasView = PKCanvasView()
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.drawingPolicy = .anyInput
        canvasView.translatesAutoresizingMaskIntoConstraints = false

        // Add views
        containerView.addSubview(pdfView)
        containerView.addSubview(canvasView)

        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: containerView.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            canvasView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            canvasView.topAnchor.constraint(equalTo: containerView.topAnchor),
            canvasView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        context.coordinator.setup(pdfView: pdfView, canvasView: canvasView, selectedTool: selectedTool)
        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.updateTool(selectedTool: selectedTool)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        private var pdfView: PDFView?
        private var canvasView: PKCanvasView?

        func setup(pdfView: PDFView, canvasView: PKCanvasView, selectedTool: EditorTool) {
            self.pdfView = pdfView
            self.canvasView = canvasView
            updateTool(selectedTool: selectedTool)
        }

        func updateTool(selectedTool: EditorTool) {
            guard let pdfView = pdfView, let canvasView = canvasView else { return }

            switch selectedTool {
            case .draw:
                pdfView.isUserInteractionEnabled = false
                canvasView.tool = PKInkingTool(.pen, color: .black, width: 3)
                canvasView.isUserInteractionEnabled = true
            case .shape, .signature:
                pdfView.isUserInteractionEnabled = false
                canvasView.isUserInteractionEnabled = false /// Placeholder for shape/signature tools
            case .none:
                pdfView.isUserInteractionEnabled = true
                canvasView.isUserInteractionEnabled = false
            }
        }
    }
}
