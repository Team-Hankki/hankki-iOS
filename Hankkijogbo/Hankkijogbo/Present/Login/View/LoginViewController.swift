//
//  LoginViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/12/24.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    let viewTitle = UILabel()
    let imageView = UIImageView()
    let loginButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAction()
    }
    
    // MARK: - Set UI
    
    override func setupStyle() {
        viewTitle.do {
            $0.attributedText = UILabel.setupAttributedText(for: SuiteStyle.h1, withText: "밥값 고민 끝,\n다함께 한끼족보를 만들어봐요")
            $0.numberOfLines = 2
        }
        
        imageView.do {
            $0.backgroundColor = .gray100
        }
        
        loginButton.do {
            $0.backgroundColor = .gray900
            $0.makeRounded(radius: 14)
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: "Apple로 계속하기",
                color: .hankkiWhite
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            
            let image = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 24)).image { _ in
                UIImage.icHeart.draw(in: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))
            }

            $0.setImage(image, for: .normal)
        }
        
    }
    
    override func setupHierarchy() {
        view.addSubviews(viewTitle, imageView, loginButton)
    }
    
    override func setupLayout() {
        viewTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(63)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(viewTitle.snp.bottom).offset(31)
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.height.equalTo(UIScreen.convertByHeightRatio(411))
        }
        loginButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(31)
            $0.height.equalTo(54)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
    }
}

private extension LoginViewController {
    func setupAction() {
        loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
    }
    
    @objc func loginButtonDidTap() {
        print("로그인")
    }
}
