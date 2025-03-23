//
//  PDFShareSheet.swift
//  PDFly
//
//  Created by Jaymeen Unadkat on 21/02/25.
//

import SwiftUI

struct PDFShareSheet: View {
    @Binding var pdfURL: URL?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            if let pdfURL = pdfURL {
                PDFKitPreviewView(url: pdfURL)
                    .frame(height: 400)
            }

            Button("Share PDF") {
//                sharePDF()
                dismiss()
            }
            .buttonStyle(.borderedProminent)

            Button("Close") {
                dismiss()
            }
        }
        .padding()
    }
}
