//
//  LiveAudioView.swift
//  Transcripto
//
//  Created by Jaymeen Unadkat on 21/02/25.
//

import SwiftUI

struct LiveAudioView: View {
    @StateObject private var speechRecognizer: SpeechRecognizer = .init()
    @State private var isRecording: Bool = false
    var body: some View {
        VStack {
            Button {
                if isRecording {
                    endTranscript()
                } else {
                    startTranscript()
                }
            } label: {
                Text(isRecording ? "Stop" : "Start")
                    .bold()
                    .font(.title)
                    .frame(width: 150, height: 50)
            }
            .buttonStyle(.borderedProminent)


            ScrollView {
                captions
            }
        }
        .onDisappear {
            speechRecognizer.stopTranscribing()
        }
    }

    func startTranscript() {
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
    }

    func endTranscript() {
        speechRecognizer.stopTranscribing()
        isRecording = false
    }

    var captions: some View {
        VStack {
            Text(speechRecognizer.transcript)
                .font(.caption)
                .foregroundStyle(.white)
                .background(Color.black.opacity(0.7))
        }
    }
}

#Preview {
    LiveAudioView()
}
