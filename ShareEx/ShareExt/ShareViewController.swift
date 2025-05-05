//
//  ShareViewController.swift
//  ShareExt
//
//  Created by Jaymeen Unadkat on 23/03/25.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

enum SharedFileType: String {
    case image, video, pdf, url
}

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ShareViewController loaded")
        handleShareExtensionOpened()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Disappeared from ShareViewController")
        close()
    }

    private func getShareLinkURL(queryItems: [String: String]?) -> URL? {
        var components = URLComponents()
        components.scheme = "ShareEx"
        components.host = "share"
        components.queryItems = queryItems?.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.url
    }

    private func copyFileToAppGroup(url: URL) -> URL? {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.your.app") else {
            return nil
        }
        let destinationURL = containerURL.appendingPathComponent(url.lastPathComponent)
        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.copyItem(at: url, to: destinationURL)
            return destinationURL
        } catch {
            print("❌ Failed to copy file: \(error)")
            return nil
        }
    }

    private func openMainApp(queryItems: [String: String]? = nil) {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
            if let url = self.getShareLinkURL(queryItems: queryItems) {
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

    func close() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

// MARK: - Handling Share

extension ShareViewController {
    private func handleShareExtensionOpened() {
        handleSharedItems()
        print("Shared Items: \(String(describing: extensionContext?.inputItems))")
    }

    private func handleSharedItems() {
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            close()
            return
        }

        for item in extensionItems {
            for attachment in item.attachments ?? [] {
                if hasType(attachment, type: .image) {
                    loadItem(from: attachment, type: .image, identifier: getTypeIdentifier(for: .image))
                    return
                }

                if hasType(attachment, type: .video) {
                    loadItem(from: attachment, type: .video, identifier: getTypeIdentifier(for: .video))
                    return
                }

                if hasType(attachment, type: .pdf) {
                    loadItem(from: attachment, type: .pdf, identifier: getTypeIdentifier(for: .pdf))
                    return
                }

                if hasType(attachment, type: .url) {
                    loadItem(from: attachment, type: .url, identifier: getTypeIdentifier(for: .url))
                    return
                }

                // Text fallback
                let textType = getPlainTextIdentifier()
                if attachment.hasItemConformingToTypeIdentifier(textType) {
                    attachment.loadItem(forTypeIdentifier: textType, options: nil) { item, _ in
                        if let text = item as? String {
                            self.handleReceivedText(text: text)
                        } else {
                            self.close()
                        }
                    }
                    return
                }
            }
        }
    }

    private func loadItem(from provider: NSItemProvider, type: SharedFileType, identifier: String) {
        provider.loadItem(forTypeIdentifier: identifier, options: nil) { item, _ in
            if let url = item as? URL {
                self.handleReceivedFile(url: url, type: type)
            } else {
                self.close()
            }
        }
    }
}

// MARK: - File Handling

extension ShareViewController {
    private func handleReceivedFile(url: URL, type: SharedFileType) {
        print("Received file of type: \(type), at url: \(url)")
        openMainApp(queryItems: ["type": type.rawValue, "\(type.rawValue)": url.absoluteString])
    }

    private func handleReceivedText(text: String) {
        print("Received text: \(text)")
        openMainApp(queryItems: ["type": "text", "text": text])
    }

    @discardableResult
    private func saveToSharedContainer(url: URL) -> URL? {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.stunlo.testios") else {
            return nil
        }

        let destURL = containerURL.appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.removeItem(at: destURL)

        do {
            try FileManager.default.copyItem(at: url, to: destURL)
            return destURL
        } catch {
            print("Copy failed: \(error)")
            return nil
        }
    }

    @discardableResult
    private func saveTextToSharedContainer(text: String) -> URL? {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.stunlo.testios") else {
            return nil
        }

        let fileName = "SharedText_\(UUID().uuidString.prefix(6)).txt"
        let destURL = containerURL.appendingPathComponent(fileName)

        do {
            try text.write(to: destURL, atomically: true, encoding: .utf8)
            return destURL
        } catch {
            print("Text write failed: \(error)")
            return nil
        }
    }
}

// MARK: - TypeIdentifier Helpers

extension ShareViewController {
    private func getTypeIdentifier(for type: SharedFileType) -> String {
        if #available(iOS 14.0, *) {
            switch type {
            case .image: return UTType.image.identifier
            case .video: return UTType.movie.identifier
            case .pdf: return UTType.pdf.identifier
            case .url: return UTType.url.identifier
            }
        } else {
            switch type {
            case .image: return kUTTypeImage as String
            case .video: return kUTTypeMovie as String
            case .pdf: return kUTTypePDF as String
            case .url: return kUTTypeURL as String
            }
        }
    }

    private func getPlainTextIdentifier() -> String {
        if #available(iOS 14.0, *) {
            return UTType.plainText.identifier
        } else {
            return kUTTypePlainText as String
        }
    }

    private func hasType(_ provider: NSItemProvider, type: SharedFileType) -> Bool {
        return provider.hasItemConformingToTypeIdentifier(getTypeIdentifier(for: type))
    }
}

/*class ShareViewController: UIViewController {
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
}*/
