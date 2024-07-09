//
//  MypageHeaderView.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

final class MypageHeaderView: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    private let profileImage: String = "image"
    private let profileNameText: String = "한끼 줍쇼"
    
    // MARK: - UI Properties
    
    private let profileView: UIView = UIView()
    private let profileImageView: UIImageView = UIImageView()
    private let profileNameLabel: UILabel = UILabel()
    
    override func setupStyle() {
        profileImageView.do {
            $0.backgroundColor = .gray400
        }
        
        profileNameLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h2,
                withText: "\(profileNameText)님\n한끼 잘 챙겨드세요",
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
