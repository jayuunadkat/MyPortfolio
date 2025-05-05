//
//  ScreenRecordingService.swift
//  TestRecordingApp
//
//  Created by Jaymeen Unadkat on 03/05/25.
//

import ReplayKit
import UIKit

final class ScreenRecordingService: NSObject, RPPreviewViewControllerDelegate {

    static let shared = ScreenRecordingService()
    private let recorder = RPScreenRecorder.shared()
    private var isRecording = false

    func startRecording(completion: @escaping (Result<Void, Error>) -> Void) {
        guard !isRecording else {
            completion(.failure(NSError(domain: "Already recording", code: -1)))
            return
        }

        recorder.isMicrophoneEnabled = true
        recorder.startRecording { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.isRecording = true
                completion(.success(()))
            }
        }
    }

    func stopRecording(presentingViewController: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        guard isRecording else {
            completion(.failure(NSError(domain: "Not recording", code: -2)))
            return
        }

        recorder.stopRecording { previewVC, error in
            self.isRecording = false

            if let error = error {
                completion(.failure(error))
            } else if let previewVC = previewVC {
                previewVC.previewControllerDelegate = self
                presentingViewController.present(previewVC, animated: true)
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "No preview available", code: -3)))
            }
        }
    }

    // Optional: Handle preview dismissal
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true)
    }
}
