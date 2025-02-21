//
//  AudioToTextView.swift
//  Transcripto
//
//  Created by Jaymeen Unadkat on 21/02/25.
//

import SwiftUI
import UniformTypeIdentifiers
import AVFoundation
import Speech

struct AudioToTextView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isProcessing = false
    @State private var showDocumentPicker = false

    var body: some View {
        VStack(spacing: 20) {
            Button(action: { showDocumentPicker = true }) {
                Text("Select Audio")
                    .bold()
                    .font(.title2)
                    .frame(width: 230, height: 50)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isProcessing)

            if isProcessing {
                ProgressView("Processing Audio...")
            }

            ScrollView {
                VStack(alignment: .leading) {
                    Text(speechRecognizer.transcript)
                        .font(.caption)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .fileImporter(isPresented: $showDocumentPicker, allowedContentTypes: [.audio]) { result in
            handleDocumentSelection(result: result)
        }
    }

    private func handleDocumentSelection(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            processAudio(url: url)
        case .failure(let error):
            print("Document selection error: \(error.localizedDescription)")
        }
    }

    private func processAudio(url: URL) {
        isProcessing = true

        guard url.startAccessingSecurityScopedResource() else {
            isProcessing = false
            return
        }

        Task {
            defer {
                url.stopAccessingSecurityScopedResource()
                isProcessing = false
            }

            do {
                let tempDirectory = FileManager.default.temporaryDirectory
                let tempURL = tempDirectory.appendingPathComponent(UUID().uuidString + ".m4a")

                try FileManager.default.copyItem(at: url, to: tempURL)

                await speechRecognizer.transcribeAudio(from: tempURL)
            } catch {
                print("Error during audio processing: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    AudioToTextView()
}
