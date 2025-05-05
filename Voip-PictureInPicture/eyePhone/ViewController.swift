//
//  ViewController.swift
//  MyCamera
//
//  Created by Jaymeen Unadkat on 05/05/25.
//

import UIKit
import AVKit

final class ViewController: UIViewController {

    private lazy var sampleBufferDisplayView = SampleBufferDisplayView()
    private lazy var captureSession = AVCaptureSession()
    private lazy var sessionQueue = DispatchQueue(label: "video.preview.session")
    private var pipController: AVPictureInPictureController?

    private var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            var isAuthorized = status == .authorized
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            return isAuthorized
        }
    }

    override func loadView() {
        view = sampleBufferDisplayView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if AVPictureInPictureController.isPictureInPictureSupported() {
            let source = AVPictureInPictureController.ContentSource(sampleBufferDisplayLayer: sampleBufferDisplayView.sampleBufferDisplayLayer,
                                                                    playbackDelegate: self)
            let pipController = AVPictureInPictureController(contentSource: source)
            pipController.canStartPictureInPictureAutomaticallyFromInline = true
            pipController.setValue(1, forKey: "controlsStyle")
            self.pipController = pipController
        }

        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .videoChat)

        Task {
            guard await isAuthorized else {
                return
            }
            configureSessionForSelfieCamera()
            sessionQueue.async {
                self.captureSession.startRunning()
            }
        }
    }


    private func configureSessionForSelfieCamera() {
        let selfieCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        guard let selfieCamera,
              let deviceInput = try? AVCaptureDeviceInput(device: selfieCamera) else {
            return
        }

        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        if captureSession.isMultitaskingCameraAccessSupported {
            captureSession.isMultitaskingCameraAccessEnabled = true
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)

        guard captureSession.canAddInput(deviceInput),
              captureSession.canAddOutput(videoOutput) else {
            return
        }

        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)

        let videoConnection = videoOutput.connection(with: .video)
        videoConnection?.videoRotationAngle = 90
        videoConnection?.isVideoMirrored = true
    }


    private func configureSessionForRearCamera() {
        let systemPreferredCamera = AVCaptureDevice.default(for: .video)
        guard let systemPreferredCamera,
              let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera) else {
            return
        }

        captureSession.beginConfiguration()
        defer {
            captureSession.commitConfiguration()
        }

        if captureSession.isMultitaskingCameraAccessSupported {
            captureSession.isMultitaskingCameraAccessEnabled = true
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)

        guard captureSession.canAddInput(deviceInput),
            captureSession.canAddOutput(videoOutput) else {
            return
        }

        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)

        let videoConnection = videoOutput.connection(with: .video)
        videoConnection?.videoRotationAngle = 0
        videoConnection?.isVideoMirrored = true
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            self.sampleBufferDisplayView.sampleBufferDisplayLayer.sampleBufferRenderer.enqueue(sampleBuffer)
        }
    }
}

extension ViewController: AVPictureInPictureSampleBufferPlaybackDelegate {

    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, setPlaying playing: Bool) {}

    func pictureInPictureControllerTimeRangeForPlayback(_ pictureInPictureController: AVPictureInPictureController) -> CMTimeRange {
        // For live content, return a time range with a duration of positiveInfinity.
        CMTimeRange(start: .zero, duration: .positiveInfinity)
    }

    func pictureInPictureControllerIsPlaybackPaused(_ pictureInPictureController: AVPictureInPictureController) -> Bool {
        false
    }

    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, didTransitionToRenderSize newRenderSize: CMVideoDimensions) {}

    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, skipByInterval skipInterval: CMTime) async {}
}
