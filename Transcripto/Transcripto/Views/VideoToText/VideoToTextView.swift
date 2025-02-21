//
//  VideoToTextView.swift
//  Transcripto
//
//  Created by Jaymeen Unadkat on 21/02/25.
//

import SwiftUI
import PhotosUI

struct VideoToTextView: View {
    @StateObject private var speechRecognizer: SpeechRecognizer = .init()
    @State private var isProcessing: Bool = false
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        VStack(spacing: 20) {
            PhotosPicker(selection: $selectedItem, matching: .videos, photoLibrary: .shared()) {
                Text("Select Video")
                    .bold()
                    .font(.title2)
                    .frame(width: 230, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(isProcessing)

            if isProcessing {
                ProgressView("Processing Video...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }

            ScrollView {
                captions
            }
        }
        .padding()
        .onChange(of: selectedItem) { oldItem, newItem in
            guard let item = newItem else { return }
            processSelectedVideo(item: item)
        }
    }

    private func processSelectedVideo(item: PhotosPickerItem) {
        Task {
            do {
                isProcessing = true
                speechRecognizer.resetTranscript()

                guard let data = try await item.loadTransferable(type: Data.self) else {
                    isProcessing = false
                    return
                }

                // Write the data to a temporary file
                let tempDirectory = FileManager.default.temporaryDirectory
                let tempURL = tempDirectory.appendingPathComponent("\(UUID().uuidString).mov")
                try data.write(to: tempURL)

                try speechRecognizer.startTranscribingVideoFromURL(videoURL: tempURL)
                isProcessing = false
            } catch {
                isProcessing = false
            }
        }
    }

    var captions: some View {
        VStack(alignment: .leading) {
            Text(speechRecognizer.transcript.isEmpty ? "Transcribed text will appear here" : speechRecognizer.transcript)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
    }
}

#Preview {
    VideoToTextView()
}
