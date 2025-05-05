//
//  ViewControllerPreview.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 23/03/25.
//

import SwiftUI
import UIKit

struct ViewControllerPreview<VC: UIViewController>: View {
    let viewController: VC

    init(viewController: VC) {
        self.viewController = viewController
    }

    var body: some View {
        ViewControllerRepresentable(viewController: viewController)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ViewControllerRepresentable<VC: UIViewController>: UIViewControllerRepresentable {
    let viewController: VC

    func makeUIViewController(context: Context) -> VC {
        return viewController
    }

    func updateUIViewController(_ uiViewController: VC, context: Context) {}
}
