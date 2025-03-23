//
//  PDFKitView.swift
//  PDFly
//
//  Created by Jaymeen Unadkat on 21/02/25.
//

import SwiftUI
import PDFKit
import PencilKit

// MARK: - PDFKit View with Drawing Support
struct PDFKitView: UIViewRepresentable {
    let pdfDocument: PDFDocument
    var isDrawingMode: Bool

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()

        // PDFView Setup
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.translatesAutoresizingMaskIntoConstraints = false

        // PKCanvasView Setup
        let canvasView = PKCanvasView(frame: .zero)
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 3)
        canvasView.translatesAutoresizingMaskIntoConstraints = false

        // Synchronize zoom & scroll
        pdfView.addObserver(context.coordinator, forKeyPath: "scaleFactor", options: .new, context: nil)
        context.coordinator.pdfView = pdfView
        context.coordinator.canvasView = canvasView

        // Add views
        containerView.addSubview(pdfView)
        containerView.addSubview(canvasView)

        // Constraints
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

        context.coordinator.toggleDrawing(isEnabled: isDrawingMode)
        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.toggleDrawing(isEnabled: isDrawingMode)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        weak var pdfView: PDFView?
        weak var canvasView: PKCanvasView?

        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            guard keyPath == "scaleFactor", let pdfView = pdfView, let canvasView = canvasView else { return }
            canvasView.transform = CGAffineTransform(scaleX: pdfView.scaleFactor, y: pdfView.scaleFactor)
        }

        func toggleDrawing(isEnabled: Bool) {
            pdfView?.isUserInteractionEnabled = !isEnabled
            canvasView?.isUserInteractionEnabled = isEnabled
        }
    }
}
