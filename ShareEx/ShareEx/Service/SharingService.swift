//
//  SharingService.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 16/04/25.
//

import Foundation

enum SharedContentType: String {
    case image
    case video
    case pdf
    case url
    case text
    /**
     (imageData: Data)
     (url: URL)
     (pdf: URL)
     (url: URL)
     (text: String)
     */

    init?(rawValue: String?) {
        guard let raw = rawValue?.lowercased(),
              let type = SharedContentType(rawValue: raw) else {
            return nil
        }
        self = type
    }
}
 
protocol SharingService {
    func handleSharedURL(_ url: URL)
    func handlePendingSharedURL(_ pendingSharedURL: URL)
    func cleanUp()
    
    func getSharedContent() -> (type: SharedContentType?, value: Any?)
    func hasShareHandlingPending() -> Bool 
}

class SharingServiceImpl: SharingService {

    private static let shareScheme = "ShareEx"
    private static let shareHost = "share"

    private var sharedContent: SharedContentType? = nil
    private var sharedContentValue: Any? = nil
    
    private var isPendingSharedURLHandling: Bool = false
    
    private init() {}
    static let shared: SharingServiceImpl = .init()

    func handleSharedURL(_ url: URL) {
        guard url.scheme == Self.shareScheme,
              url.host == Self.shareHost,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            print("Invalid share URL: \(url)")
            return
        }

        let queryParams: [String: String] = Dictionary(
            uniqueKeysWithValues: queryItems.compactMap { item in
                guard let value = item.value else { return nil }
                return (item.name, value)
            }
        )

        print("Parsed share params: \(queryParams)")

        guard let type = SharedContentType(rawValue: queryParams["type"]), let value = queryParams[type.rawValue] else {
            print("Unsupported share type in params")
            return
        }
        
        self.sharedContent = type
        self.sharedContentValue = value

        if let url = URL(string: value), let data = try? Data(contentsOf: url) {


            print("Data loaded: \(data) bytes")
        }

        print("Received shared content: \(type), \(value)")
    }
    
    func handlePendingSharedURL(_ pendingSharedURL: URL) {
        handleSharedURL(pendingSharedURL)
        isPendingSharedURLHandling = true
    }
    
    func cleanUp() {
        sharedContent = nil
        sharedContentValue = nil
        isPendingSharedURLHandling = false
    }
    
    func getSharedContent() -> (type: SharedContentType?, value: Any?) {
        return (sharedContent, sharedContentValue)
    }
    
    func hasShareHandlingPending() -> Bool {
        return isPendingSharedURLHandling
    }
}
