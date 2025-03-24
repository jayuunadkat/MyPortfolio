//
//  ShareViewController.swift
//  ShareExt
//
//  Created by Jaymeen Unadkat on 23/03/25.
//

import UIKit
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ShareViewController loaded")

        openMainApp()
    }

    override func viewDidDisappear(_ animated: Bool) {
        print("Disaappeared from ShareViewController")
        close()
    }

    private func getShareLinkURL(queryItems: [String: String]?) -> URL? {
        var components: URLComponents = URLComponents()
        components.scheme = "ShareEx"
        components.host = "share"
        components.queryItems = queryItems?.map { URLQueryItem(name: $0.key, value: $0.value) }

        return components.url
        //Example: ShareEx://share?targetId=target.id&targetName=target.name
    }

    private func checkTypes() {
        guard
            let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first else {
            close()
            return
        }

        let textDataType = UTType.plainText.identifier
        if itemProvider.hasItemConformingToTypeIdentifier(textDataType) {


            itemProvider.loadItem(forTypeIdentifier: textDataType , options: nil) { (providedText, error) in
                if let _ = error {
                    self.close()
                    return
                }

                if let text = providedText as? String {
                    print("Provided text: \(text)")
                } else {
                    self.close()
                    return
                }
            }

        } else { close() }

    }

    func close() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    private func openMainApp() {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
            if let url = self.getShareLinkURL(queryItems: ["targetId": "target.id", "targetName": "target.name"]) {
                _ = self.openURL(url)
            }
        })
    }

    @objc private func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                application.open(url)
                self.close()
            }
            responder = responder?.next
        }
        return false
    }
}
