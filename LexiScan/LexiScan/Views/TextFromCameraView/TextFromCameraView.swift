//
//  TextFromCameraView.swift
//  LexiScan
//
//  Created by Jaymeen Unadkat on 21/02/25.
//


import SwiftUI
import Vision
import VisionKit

struct TextFromCameraView: View {
    @State private var recognizedText: String = ""
    @State private var showLiveTextScanner = false

    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                Text(recognizedText.isEmpty ? "Detected text will appear here" : recognizedText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            }

            Button(action: { showLiveTextScanner = true }) {
                Label("Scan with Camera", systemImage: "camera.viewfinder")
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Text From Camera")
        .sheet(isPresented: $showLiveTextScanner) {
            LiveCameraTextScanner { text in
                recognizedText = text
            }
        }
    }
}
