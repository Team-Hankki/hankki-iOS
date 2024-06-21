//
//  UIViewController+.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import UIKit

extension UIViewController {
    
    /// 네비게이션바를 숨기는 메서드
    func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /// 숨긴 네비게이션 바를 보이게 하는 메서드
    func showNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    /// 화면 밖 터치시 키보드를 내려 주는 메서드
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func changeStatusBarBgColor(statusBarColor: UIColor?) {
        guard #available(iOS 13.0, *) else {
            guard let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView else { return }
            statusBar.backgroundColor = statusBarColor
            return
        }

        guard let window = UIApplication.shared.windows.first,
              let statusBarManager = window.windowScene?.statusBarManager else { return }

        let statusBarView = UIView(frame: statusBarManager.statusBarFrame)
        statusBarView.backgroundColor = statusBarColor
        window.addSubview(statusBarView)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
