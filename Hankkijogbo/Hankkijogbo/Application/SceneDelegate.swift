//
//  SceneDelegate.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import UIKit
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        checkAppleAccountStatus()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
}

private extension SceneDelegate {
    func checkAppleAccountStatus() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let userId: String = UserDefaults.standard.getUserId()
        
        appleIDProvider.getCredentialState(forUserID: userId) { (credentialState, _) in
            switch credentialState {
            case .authorized:
                return
                
            default:
                print("🛠️ RESTART APPLICATION 🛠️ - NO ACCESS")
                UIApplication.resetApp()
                return
            }
        }
    }
}
