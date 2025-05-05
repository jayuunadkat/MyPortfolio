//
//  HomeView.swift
//  RecorderDesk
//
//  Created by Jaymeen Unadkat on 05/05/25.
//

import SwiftUI

struct HomeView: View {
    @State private var isRecording = false
    @State var service: ScreenRecorder!
//    let service: ScreenRecordingService = ScreenRecordingService()
    var body: some View {
        VStack {

            Button {
                isRecording.toggle()
                toggleRecording()
            } label: {
                Text(isRecording ? "Stop Recording" : "Start Recording")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .task {
            initializeRecording()
        }
    }

    private func initializeRecording() {
        Task {
            do {
                let url = URL(filePath: FileManager.default.currentDirectoryPath).appending(path: "recording \(Date()).mov")

                self.service = try await ScreenRecorder(url: url, displayID: CGMainDisplayID(), cropRect: nil, mode: .h264_sRGB)

                print("Service: \(service)")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func toggleRecording() {
        Task {
            do {
                if isRecording {
                    try await self.service.start()
                } else {
                    try await self.service.stop()
                }
            } catch {

            }
        }
    }

}

#Preview {
    HomeView()
}
