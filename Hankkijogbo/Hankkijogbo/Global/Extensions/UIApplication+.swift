//
//  UIApplication+.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/16/24.
//

import UIKit

extension UIApplication {
    
    /// SafeArea의 Top Height 즉 상태바의 높이를 반환하는 함수
    static func getStatusBarHeight() -> CGFloat {
        let scenes = self.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let safeAreaTopSize = window?.safeAreaInsets.top
        return safeAreaTopSize ?? 0
    }
    
    /// 어플리케이션에 저장되어있는 모든 user 정보를 초기화한다.
    /// 이후 Splash 화면으로 넘어간다.
    static func resetApp() {
        // 어플리케이션에서 user information 삭제
        UserDefaults.standard.removeUserInformation()
        
        // Splash 화면으로 이동
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    let splashViewController = SplashViewController()
                    window.rootViewController = splashViewController
                }
            }
        }
    }
    
    // view controller 외의 곳에서 alert을 호출하려는 경우
    static func showAlert(
        image: UIImage? = nil,
        titleText: String,
        subText: String = "",
        secondaryButtonText: String = "",
        primaryButtonText: String,
        secondaryButtonHandler: (() -> Void)? = nil,
        primaryButtonHandler: (() -> Void)? = nil,
        hightlightedText: String = "",
        hightlightedColor: UIColor? = nil
    ) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate,
           let rootViewController = delegate.window?.rootViewController {
            rootViewController.showAlert(
                image: image,
                titleText: titleText,
                subText: subText,
                secondaryButtonText: secondaryButtonText,
                primaryButtonText: primaryButtonText,
                secondaryButtonHandler: secondaryButtonHandler,
                primaryButtonHandler: primaryButtonHandler,
                hightlightedText: hightlightedText,
                hightlightedColor: hightlightedColor
            )
        }
    }
    
    /// 하단에 뜨는 검정 토스트뷰를 띄우는 함수
    static func showBlackToast(message: String, action: (() -> Void)? = nil) {
        
        let toastView = BlackToastView(message: message, action: action)
        
        // 토스트 메시지를 최상위 윈도우에 추가
        if let topWindow = shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .filter({ $0.isKeyWindow }).first {
            
            topWindow.addSubview(toastView)
            toastView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                if UIScreen.hasNotch {
                    $0.bottom.equalTo(topWindow.safeAreaLayoutGuide).offset(-16)
                } else {
                    $0.bottom.equalToSuperview().inset(16)
                }
            }
        }
    }
}
