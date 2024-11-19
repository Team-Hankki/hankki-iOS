//
//  MypageHeaderView.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

extension MypageHeaderView {
    struct Model {
        let name: String
    }
}

final class MypageHeaderView: BaseCollectionViewCell {
    
    // MARK: - UI Properties
    
    private let profileImageView: UIImageView = UIImageView()
    private let profileNameLabel: UILabel = UILabel()
    private let profileGreetingLabel: UILabel = UILabel()
    
    override func setupStyle() {
        profileImageView.do {
            $0.image = UIImage.imgMypageProfileDefault
        }
        
        profileNameLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h3,
                color: .gray900
            )
        }
        
        profileGreetingLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.body4,
                withText: StringLiterals.Mypage.Header.greeting,
                color: .gray500
            )
        }
        
    }
    
    override func setupHierarchy() {
        self.addSubviews(profileImageView, profileNameLabel, profileGreetingLabel)
        
    }
    
    override func setupLayout() {
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(62)
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(22)
        }
        
        profileNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView).inset(7.5)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(14)
        }
        
        profileGreetingLabel.snp.makeConstraints {
            $0.top.equalTo(profileNameLabel.snp.bottom)
            $0.leading.equalTo(profileNameLabel)
        }
    }
}

extension MypageHeaderView {
    func dataBind(_ model: Model) {
        profileNameLabel.text = model.name + StringLiterals.Mypage.Header.nicknameFinal
    }
}
