//
//  DrawingOverlayView.swift
//  PDFly
//
//  Created by Jaymeen Unadkat on 21/02/25.
//

import SwiftUI
import PencilKit

struct DrawingOverlayView: UIViewRepresentable {
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.drawingPolicy = .anyInput
//        canvasView.allowsFingerDrawing = true
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}
