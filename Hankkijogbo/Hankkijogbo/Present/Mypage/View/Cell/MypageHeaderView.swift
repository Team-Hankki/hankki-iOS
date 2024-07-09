//
//  MypageHeaderView.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

final class MypageHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    let profileImage: String = "image"
    let profileNameText: String = "한끼 줍쇼"
    
    // MARK: - UI Properties
    
    let profileView: UIView = UIView()
    let profileImageView: UIImageView = UIImageView()
    let profileNameLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
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
    
    private func setupHierarchy() {
        self.addSubviews(profileView)
        profileView.addSubviews(profileImageView, profileNameLabel)
    }
    
    private func setupLayout() {
        profileView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(98)
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
