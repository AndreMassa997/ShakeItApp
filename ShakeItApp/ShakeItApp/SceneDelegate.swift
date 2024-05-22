//
//  SceneDelegate.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 17/05/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let mainViewModel = MainViewModel(networkProvider: NetworkManager(), imageProvider: ImagesManager())
        let mainViewController = MainViewController(viewModel: mainViewModel)
        
        if let storedPalette = AppPreferences.shared.storedPalette{
            AppPreferences.shared.setupUserPalette(newPalette: storedPalette == "light" ? LightPalette() : DarkPalette())
        } else {
            //User has not decided palette yet, apply automatic
            AppPreferences.shared.setupUserPalette(newPalette: window.traitCollection.userInterfaceStyle == .dark ? DarkPalette() : LightPalette())
        }
        
        let navigationController = UINavigationController(rootViewController: mainViewController)
        window.rootViewController = navigationController
        self.window?.backgroundColor = .white
        self.window = window
        window.makeKeyAndVisible()
    }
}

