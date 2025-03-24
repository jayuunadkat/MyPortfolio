//
//  SceneDelegate.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 23/03/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setupWindow(windowScene: windowScene)
    }

    private func setupWindow(windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .systemBackground

        let rootVC: UIViewController = HomeRouter.createModule()
        let rootNavVC: UINavigationController = UINavigationController(rootViewController: rootVC)
        window.rootViewController = rootNavVC

        self.window = window
        window.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        handleOpenURL(url: url)
    }



    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    private func handleOpenURL(url: URL) {
        guard url.scheme == "ShareEx", let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }

        if let host = components.host {
            switch host {
            case "share":
                handleShareExtensionURL(url)
            default:
                break
            }
        }

    }


    private func handleShareExtensionURL(_ url: URL) {
        print("Share extension URL received: \(url)")
        let rootNavVC = window?.rootViewController as! UINavigationController
        let shareWithVC = ShareWithSheetViewController()

        let navVC = UINavigationController(rootViewController: shareWithVC)
        navVC.modalPresentationStyle = .pageSheet

        rootNavVC.present(navVC, animated: true)
    }
}
