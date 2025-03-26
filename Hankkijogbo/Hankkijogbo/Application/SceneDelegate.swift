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
        window?.makeKeyAndVisible()
        
        guard let urlContext = connectionOptions.urlContexts.first else {
            window?.rootViewController = SplashViewController()
            return
        }
        
        // 딥링크로 앱이 시작된 경우 처리합니다
        handleDeeplink(urlContext.url)
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
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlContext = URLContexts.first else { return }
        
        // 앱이 실행중일 때, 딥링크로 접속했을 경우 처리를 진행합니다.
        handleDeeplink(urlContext.url)
    }
}

private extension SceneDelegate {
    // 애플 계정의 사용자의 userID가 존재하는지 확인합니다.
    // 설정에서 앱 탈퇴를 하는 경우를 사전에 방지합니다.
    func checkAppleAccountStatus() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let userId: String = UserDefaults.standard.getUserId()
        
        if userId.isEmpty { return }
        
        appleIDProvider.getCredentialState(forUserID: userId) { (credentialState, _) in
            DispatchQueue.main.async {
                switch credentialState {
                case .authorized:
                    self.checkServerAccountStatus()
                    return
                default:
                    print("🛠️ RESTART APPLICATION 🛠️ - NO ACCESS")
                    UIApplication.resetApp()
                }
            }
        }
    }
    
    /// 서버에 사용자의 정보가 저장되어있는지 확인합니다.
    func checkServerAccountStatus() {
        let accessToken: String = UserDefaults.standard.getAccessToken()
        
        if !accessToken.isEmpty {
            getMe()
        }
    }
    
    /// 딥링크로 앱이 시작된 경우, url 에 따라 view를 처리합니다
    private func handleDeeplink(_ url: URL) {
        guard url.scheme == "kakao\(Config.Kakao)" else { return }
        
        switch url.host {
        case "kakaolink":
            let queryParameters: [String: String] = url.getQueryParameters()
            
            switch Set(queryParameters.keys) {
            case ["sharedZipId"]:
                guard let zipId = Int(queryParameters["sharedZipId"] ?? "") else { print("❌ NO-EXISTENT DEEP LINK ❌ - ZIP ID IS ERROR"); return }
                handleSharedZipDeeplink(zipId: zipId)
                
            default:
                print("❌ NO-EXISTENT DEEP LINK ❌ - NO PARAMETERS")
            }
        default:
            print("❌ NO-EXISTENT DEEP LINK ❌")
        }
    }
    
    /// 족보 공유의 딥링크를 이용한 경우, zipVC를 반환합니다.
    private func handleSharedZipDeeplink(zipId: Int) {
        if UserDefaults.standard.isLogin {
            getZipOwnership(zipId: zipId)
        } else {
            presentZipDetails(zipId: zipId, isOwnership: false)
        }
    }
    
    /// 공유받은 족보 상세 페이지로 이동
    private func presentZipDetails(zipId: Int, isOwnership: Bool) {
        let tabBarController = TabBarController()
        tabBarController.selectedIndex = 2
        let navigationController = HankkiNavigationController(rootViewController: tabBarController)
        
        window?.rootViewController = navigationController
        
        if isOwnership {
            navigationController.pushViewController(ZipDetailViewController(zipId: zipId, type: .myZip), animated: false)
        } else {
            navigationController.pushViewController(ZipDetailViewController(zipId: zipId, type: .sharedZip), animated: false)
        }
    }
}

// MARK: - API
private extension SceneDelegate {
    func getMe() {
        NetworkService.shared.userService.getMe { result in
            switch result {
            case .notFound:
                print("🛠️ RESTART APPLICATION 🛠️ - NO ACCOUNT")
                print("To.makers")
                print("개발서버 or 릴리즈서버 둘 중 하나에만 저장 된 계정이에요.")
                print("계정을 삭제했다 깔아주시거나, 설정에 들어가서 완전히 회원 탈퇴를 해주세요.")
                print("Iphone의 Setting -> Sign-In & Security -> Sign in With Apple -> Hankki -> Stop Using Apple ID")
                print("From.서현")
                UIApplication.resetApp()
            case .unAuthorized:
                self.postReissue()
            default:
                return
            }
        }
    }
    
    func postReissue() {
        NetworkService.shared.authService.postReissue { result in
            switch result {
            case .success(let response):
                UserDefaults.standard.saveTokens(accessToken: response?.data.accessToken ?? "",
                                                 refreshToken: response?.data.refreshToken ?? "")
            default:
                // 401, 404 ...
                // access token을 재발급 받는 중 error가 났을 경우
                // refresh token이 정상적이지 않을 경우
                // 로그인을 다시 진행해 refresh token을 재발급 받는다.
                UIApplication.resetApp()
            }
        }
    }
    
    func getZipOwnership(zipId: Int) {
        NetworkService.shared.zipService.getZipOwnership(zipId: zipId) { result in
            switch result {
            case .success(let response):
                guard let isOwnership = response?.data.isOwner else { return }
                self.presentZipDetails(zipId: zipId, isOwnership: isOwnership)
                
            case .notFound:
                fatalError("\(zipId)의 족보가 없습니다")
            
            default:
                fatalError("잘못된 접근입니다!")
            }
        }
    }
}
