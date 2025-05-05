//
//  HomeViewController.swift
//  TestRecordingApp
//
//  Created by Jaymeen Unadkat on 03/05/25.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {

    private let startStopButton = UIButton(type: .system)
    private var isRecording = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupToggleButton()
    }

    private func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = UIColor.systemTeal
        appearance.backgroundColor = UIColor.systemTeal
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        title = "Screen Recorder"
    }

    private func setupToggleButton() {
        startStopButton.setTitle("Start Recording", for: .normal)
        startStopButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
        startStopButton.frame = CGRect(x: 80, y: 200, width: 250, height: 50)
        startStopButton.setTitle("Start Recording", for: .normal)
        startStopButton.setTitleColor(.white, for: .normal)
        startStopButton.backgroundColor = .systemTeal
        startStopButton.layer.cornerRadius = 10
        startStopButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        startStopButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)

        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startStopButton)

        NSLayoutConstraint.activate([
            startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startStopButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startStopButton.widthAnchor.constraint(equalToConstant: 200),
            startStopButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        view.addSubview(startStopButton)
    }

    @objc private func toggleRecording() {
        if isRecording {
            ScreenRecordingService.shared.stopRecording(presentingViewController: self) { [weak self] result in
                switch result {
                case .success:
                    self?.isRecording = false
                    self?.startStopButton.setTitle("Start Recording", for: .normal)
                case .failure(let error):
                    print("Stop error: \(error)")
                }
            }
        } else {
            ScreenRecordingService.shared.startRecording { [weak self] result in
                switch result {
                case .success:
                    self?.isRecording = true
                    self?.startStopButton.setTitle("Stop Recording", for: .normal)
                case .failure(let error):
                    print("Start error: \(error)")
                }
            }
        }
    }

    private func showError(_ error: Error) {
        showAlert("Error", message: error.localizedDescription)
    }

    private func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


struct HomeView: View {
    var body: some View {
        ViewControllerPreview(viewController: HomeViewController())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
