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
}
