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
    
    private let profileView: UIView = UIView()
    private let profileImageView: UIImageView = UIImageView()
    private let profileNameLabel: UILabel = UILabel()
    
    override func setupStyle() {
        profileImageView.do {
            $0.image = UIImage.imgMypageProfileDefault
        }
        
        profileNameLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h2,
                color: .gray900
            )
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }
    }
    
    override func setupHierarchy() {
        self.addSubview(profileView)
        profileView.addSubviews(profileImageView, profileNameLabel)
    }
    
    override func setupLayout() {
        profileView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }

        profileImageView.snp.makeConstraints {
            $0.size.equalTo(98)
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }

        profileNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(19)
            $0.centerX.equalToSuperview()
        }
    }
}

extension MypageHeaderView {
    func dataBind(_ model: Model) {
        profileNameLabel.text = model.name + StringLiterals.Mypage.Header.greeting
    }
}
