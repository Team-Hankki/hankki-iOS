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
}
