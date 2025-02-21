//
//  LiveCameraTextScanner.swift
//  LexiScan
//
//  Created by Jaymeen Unadkat on 21/02/25.
//


import SwiftUI
import Vision
import VisionKit

struct LiveCameraTextScanner: UIViewControllerRepresentable {
    var completion: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion)
    }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var completion: (String) -> Void

        init(completion: @escaping (String) -> Void) {
            self.completion = completion
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var detectedText = ""

            for pageIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
                let request = VNRecognizeTextRequest { request, error in
                    if let results = request.results as? [VNRecognizedTextObservation] {
                        let pageText = results.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                        detectedText += pageText + "\n"
                    }
                }
                request.recognitionLanguages = ["en", "fr", "de"]
                request.recognitionLevel = .accurate
                try? requestHandler.perform([request])
            }

            DispatchQueue.main.async {
                self.completion(detectedText)
                controller.dismiss(animated: true)
            }
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            controller.dismiss(animated: true)
        }
    }
}
