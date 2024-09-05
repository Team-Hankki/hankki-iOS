//
//  SplashViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import UIKit

final class SplashViewController: BaseViewController {
    // MARK: - UI Components
    
    let titleLabel: UILabel = UILabel()
    let logoImageView: UIImageView = UIImageView()
    let logoTextView: UIImageView = UIImageView()
    
    // MARK: - Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if isLogin() {
            presentHomeView()
        } else {
            presentLoginView()
        }
    }
    
    // MARK: - setup UI
    
    override func setupStyle() {
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.subtitle1, 
                                                            withText: "함께 만드는 8000원 이하 식당 지도",
                                                            color: .gray400)
            $0.numberOfLines = 1
        }
        
        logoTextView.do {
            $0.image = .imgSplashTextLogo
        }
        
        logoImageView.do {
            $0.image = .imgSplashImageLogo
        }
    }
    
    override func setupHierarchy() {
        view.addSubviews(titleLabel, logoTextView, logoImageView)
    }
    
    override func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIScreen.convertByHeightRatio(190))
            $0.centerX.equalToSuperview()
        }
        
        logoTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(logoTextView.snp.bottom).offset(42)
            $0.centerX.equalToSuperview()
        }
    }
}

private extension SplashViewController {
    func isLogin() -> Bool {
        return !UserDefaults.standard.getAccesshToken().isEmpty
    }
    
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
