//
//  HankkiInfoView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 12/23/24.
//

import UIKit

final class HankkiInfoView: BaseView {
    
    // MARK: - UI Components
    
    private let categoryImageView: UIImageView = UIImageView()
    private let categoryLabel: UILabel = UILabel()
    private let nameLabel: UILabel = UILabel()
    let heartButton: UIButton = UIButton()
    let myZipButton: UIButton = UIButton()
    private let separatorView: UIView = UIView()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubviews(
            categoryImageView,
            categoryLabel,
            nameLabel,
            heartButton,
            myZipButton,
            separatorView
        )
    }
    
    override func setupLayout() {
        categoryImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(22)
            $0.size.equalTo(20)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(categoryImageView.snp.trailing).offset(4)
            $0.centerY.equalTo(categoryImageView)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(categoryImageView.snp.bottom).offset(2)
            $0.leading.equalToSuperview().inset(22)
        }
        
        heartButton.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalTo(nameLabel)
        }
        
        myZipButton.snp.makeConstraints {
            $0.leading.equalTo(heartButton.snp.trailing).offset(16)
            $0.centerY.equalTo(heartButton)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(heartButton.snp.bottom).offset(2)
            $0.leading.equalTo(heartButton)
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.backgroundColor = .hankkiWhite
        }
        
        categoryLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.caption4, color: .gray900)
        }
        
        nameLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.h3, color: .gray900)
        }
        
        heartButton.do {
            $0.setImage(.icHeart, for: .normal)
            $0.configuration = .plain()
            $0.configuration?.imagePadding = 4
            $0.configuration?.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        }
           
        myZipButton.do {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.body8,
                withText: StringLiterals.HankkiDetail.myZip,
                color: .gray800
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            $0.setImage(.icAddZip, for: .normal)
            $0.configuration = .plain()
            $0.configuration?.imagePadding = 4
            $0.configuration?.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        }
        
        separatorView.do {
            $0.backgroundColor = .gray100
        }
    }
}

extension HankkiInfoView {
    
    func bindData(category: String, categoryImageUrl: String, name: String, heartCount: String, isLiked: Bool) {
        categoryLabel.text = category
        categoryImageView.setKFImage(url: categoryImageUrl)
        nameLabel.text = name
        if let attributedTitle = UILabel.setupAttributedText(
            for: PretendardStyle.body8,
            withText: heartCount,
            color: .gray800
        ) {
            heartButton.setAttributedTitle(attributedTitle, for: .normal)
        }
        heartButton.setImage(isLiked ? .icHeartRed : .icHeart, for: .normal)
    }
}
