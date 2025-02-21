//
//  TextFromImageView.swift
//  LexiScan
//
//  Created by Jaymeen Unadkat on 21/02/25.
//


import SwiftUI
import Vision

struct TextFromImageView: View {
    @State private var recognizedText: String = ""
    @State private var showImagePicker = false

    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                Text(recognizedText.isEmpty ? "Detected text will appear here" : recognizedText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            }
            Button(action: { showImagePicker = true }) {
                Label("Pick Image", systemImage: "photo")
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Text From Image")
        .sheet(isPresented: $showImagePicker) {
            ImagePicker { image in
                if let image = image {
                    recognizeText(from: image)
                }
            }
        }
    }

    private func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            if let results = request.results as? [VNRecognizedTextObservation] {
                let detectedText = results.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                DispatchQueue.main.async {
                    recognizedText = detectedText
                }
            }
        }
//        request.recognitionLanguages = ["en", "fr", "de"]
        request.recognitionLanguages = ["gu"]
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        try? requestHandler.perform([request])
    }
}
