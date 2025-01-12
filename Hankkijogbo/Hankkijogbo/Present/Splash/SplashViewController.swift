//
//  SplashViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import UIKit

final class SplashViewController: BaseViewController {
    // MARK: - UI Components

    let logoImageView: UIImageView = UIImageView()
    
    // MARK: - Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.isLogin {
            presentHomeView()
        } else {
            presentLoginView()
        }
    }
    
    // MARK: - setup UI
    
    override func setupStyle() {
        logoImageView.do {
            $0.image = .imgSplashTextLogo
        }
    }
    
    override func setupHierarchy() {
        view.addSubviews(logoImageView)
    }
    
    override func setupLayout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(UIScreen.convertByHeightRatio(310))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.convertByWidthRatio(183))
        }
    }
}

private extension SplashViewController {
    func presentHomeView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let navigationController = HankkiNavigationController(rootViewController: TabBarController())
            self.view.window?.rootViewController = navigationController
            navigationController.popToRootViewController(animated: false)
        }
    }
    
    func presentLoginView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.view.window?.rootViewController = LoginViewController()
        }
    }
}
