//
//  PDFEditorFullScreenView.swift
//  PDFly
//
//  Created by Jaymeen Unadkat on 21/02/25.
//


import PencilKit
import PDFKit
import SwiftUI

struct PDFEditorFullScreenView: View {
    let pdfDocument: PDFDocument
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTool: EditorTool = .none

    private func toggleTool(_ tool: EditorTool) {
        selectedTool = (selectedTool == tool) ? .none : tool
    }

    var body: some View {
        NavigationView {
            VStack {
                PDFEditorCanvasView(pdfDocument: pdfDocument, selectedTool: selectedTool)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: { toggleTool(.draw) }) {
                        Label("Draw", systemImage: "pencil")
                            .foregroundColor(selectedTool == .draw ? .green : .primary)
                    }
                    Button(action: { toggleTool(.shape) }) {
                        Label("Shape", systemImage: "square.on.square")
                            .foregroundColor(selectedTool == .shape ? .green : .primary)
                    }
                    Button(action: { toggleTool(.signature) }) {
                        Label("Sign", systemImage: "signature")
                            .foregroundColor(selectedTool == .signature ? .green : .primary)
                    }
                }
            }
            .navigationTitle("PDF Editor")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


enum EditorTool {
    case none, draw, shape, signature
}
