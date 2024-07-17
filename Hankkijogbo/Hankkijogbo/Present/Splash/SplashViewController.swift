//
//  SplashViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import UIKit

final class SplashViewController: BaseViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let accessToken = UserDefaults.standard.getAccesshToken()
        
        if accessToken.isEmpty {
            // accessToken이 없는 경우 -> 로그인 뷰로 이동
            self.view.window?.rootViewController = LoginViewController()
            
        } else {
            // accessToken이 있는 경우 -> 홈 뷰로 이동
            let navigationController = HankkiNavigationController(rootViewController: TabBarController())
            self.view.window?.rootViewController = navigationController
            navigationController.popToRootViewController(animated: false)
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .yellow
    }
}