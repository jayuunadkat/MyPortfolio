//
//  PDFEditorView.swift
//  PDFly
//
//  Created by Jaymeen Unadkat on 21/02/25.
//

import SwiftUI
import PDFKit

struct PDFEditorView: View {
    @State private var pdfDocument: PDFDocument? = nil
    @State private var showPDFEditor = false

    var body: some View {
        NavigationView {

            VStack {
                Button("Pick PDF") {
                    showPDFEditor = false
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .sheet(isPresented: Binding(get: { pdfDocument == nil }, set: { _ in })) {
                    DocumentPicker(pdfDocument: $pdfDocument)
                }
                .fullScreenCover(isPresented: $showPDFEditor) {
                    if let document = pdfDocument {
                        PDFEditorFullScreenView(pdfDocument: document)
                    }
                }
                
                if pdfDocument != nil {
                    Button("Open Editor") {
                        showPDFEditor = true
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
    }
}
