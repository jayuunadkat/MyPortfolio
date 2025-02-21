//
//  SpeechRecognizer.swift
//  Transcripto
//
//  Created by Jaymeen Unadkat on 21/02/25.
//

import Foundation
import AVFoundation
import Speech
import SwiftUI

/// A helper for transcribing speech to text using SFSpeechRecognizer and AVAudioEngine.
actor SpeechRecognizer: ObservableObject {
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        case failedToDownloadAudio
        case failedToExtractAudio

        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            case .failedToDownloadAudio: return "Failed to download audio"
            case .failedToExtractAudio: return "Failed to extract audio from video"
            }
        }
    }
    
    @MainActor @Published var transcript: String = ""

    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?
    
    /**
     Initializes a new speech recognizer. If this is the first time you've used the class, it
     requests access to the speech recognizer and the microphone.
     */
    init() {
        recognizer = SFSpeechRecognizer()
        guard recognizer != nil else {
            transcribe(RecognizerError.nilRecognizer)
            return
        }
        
        Task {
            do {
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                transcribe(error)
            }
        }
    }
    
    @MainActor func startTranscribing() {
        Task {
            await transcribe()
        }
    }
    
    @MainActor func resetTranscript() {
        Task {
            await reset()
        }
    }
    
    @MainActor func stopTranscribing() {
        Task {
            await reset()
        }
    }
    
    /**
     Begin transcribing audio.
     
     Creates a `SFSpeechRecognitionTask` that transcribes speech to text until you call `stopTranscribing()`.
     The resulting transcription is continuously written to the published `transcript` property.
     */
    private func transcribe() {
        guard let recognizer, recognizer.isAvailable else {
            self.transcribe(RecognizerError.recognizerIsUnavailable)
            return
        }
        
        do {
            let (audioEngine, request) = try Self.prepareEngine()
            self.audioEngine = audioEngine
            self.request = request
            self.task = recognizer.recognitionTask(with: request, resultHandler: { [weak self] result, error in
                self?.recognitionHandler(audioEngine: audioEngine, result: result, error: error)
            })
        } catch {
            self.reset()
            self.transcribe(error)
        }
    }
    
    /// Reset the speech recognizer.
    private func reset() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    nonisolated private func recognitionHandler(audioEngine: AVAudioEngine, result: SFSpeechRecognitionResult?, error: Error?) {
        let receivedFinalResult = result?.isFinal ?? false
        let receivedError = error != nil
        
        if receivedFinalResult || receivedError {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        if let result {
            transcribe(result.bestTranscription.formattedString)
        }
    }
    
    
    nonisolated private func transcribe(_ message: String) {
        Task { @MainActor in
            transcript = message
            print("Transcribed: \(message)")
        }
    }
    nonisolated private func transcribe(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        Task { @MainActor [errorMessage] in
            transcript = "<< \(errorMessage) >>"
        }
    }
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}

extension SpeechRecognizer {

    @MainActor func startTranscribingVideoFromURL(videoURL: URL) throws {
        Task {
            try await extractAudioFromVideo(url: videoURL)
        }
    }

    /// Extracts the audio from the video and exports it as a temporary file
    private func extractAudioFromVideo(url: URL) async throws {
        let asset = AVURLAsset(url: url)

        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) else {
            transcribe(RecognizerError.failedToExtractAudio)
            return
        }

        let duration = try await asset.load(.duration)
        let tempDirectory = FileManager.default.temporaryDirectory
        let audioURL = tempDirectory.appendingPathComponent("\(UUID().uuidString).m4a")

        exportSession.outputFileType = .m4a
        exportSession.timeRange = CMTimeRange(start: .zero, duration: duration)

        do {
            try await exportSession.export(to: audioURL, as: .m4a)

            transcribeAudio(from: audioURL)

        } catch {
            print("Export failed: \(error.localizedDescription)")
            transcribe(RecognizerError.failedToExtractAudio)
        }
    }




    /// Function to transcribe the audio once extracted
    func transcribeAudio(from url: URL) {
        do {
            let audioFile = try AVAudioFile(forReading: url)
            let format = audioFile.processingFormat
            let frameCount = UInt32(audioFile.length)
            guard let audioBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
                transcribe(RecognizerError.failedToExtractAudio)
                return
            }
            try audioFile.read(into: audioBuffer)

            guard let recognizer = recognizer, recognizer.isAvailable else {
                transcribe(RecognizerError.recognizerIsUnavailable)
                return
            }

            let request = SFSpeechAudioBufferRecognitionRequest()
            request.append(audioBuffer)

            let audioEngine = AVAudioEngine()
            self.audioEngine = audioEngine
            self.request = request

            self.task = recognizer.recognitionTask(with: request, resultHandler: { [weak self] result, error in
                guard let self = self else { return }
                self.recognitionHandler(audioEngine: audioEngine, result: result, error: error)
            })

        } catch {
            transcribe(error)
        }
    }

}
