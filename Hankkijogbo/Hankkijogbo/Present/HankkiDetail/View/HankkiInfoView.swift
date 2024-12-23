//
//  HankkiInfoView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 12/23/24.
//

import UIKit

final class HankkiInfoView: BaseView {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let categoryImageView: UIImageView = UIImageView()
    private let categoryLabel: UILabel = UILabel()
    private let hankkiLabel: UILabel = UILabel()
    private let heartButton: UIButton = UIButton()
    private let myZipButton: UIButton = UIButton()
    private let separatorView: UIView = UIView()
    
    // MARK: - Life Cycle
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubviews(
            categoryImageView,
            categoryLabel,
            hankkiLabel,
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
        
        hankkiLabel.snp.makeConstraints {
            $0.top.equalTo(categoryImageView.snp.bottom).offset(2)
            $0.leading.equalToSuperview().inset(22)
        }
        
        heartButton.snp.makeConstraints {
            $0.top.equalTo(hankkiLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(22)
        }
        
        myZipButton.snp.makeConstraints {
            $0.leading.equalTo(heartButton.snp.trailing).offset(16)
            $0.centerY.equalTo(heartButton)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(heartButton.snp.bottom).offset(12)
            $0.leading.equalTo(heartButton)
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.backgroundColor = .hankkiWhite
        }
        
        categoryImageView.do {
            $0.image = .icHomeSelected
        }
        
        categoryLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.caption4,
                                                            withText: "일식",
                                                            color: .gray900)
        }
        
        hankkiLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.h1,
                                                            withText: "아리가또 고자이마스",
                                                            color: .gray900)
        }
        
        heartButton.do {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.body8,
                withText: "24",
                color: .gray800
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            $0.setImage(.icHeart, for: .normal)
            $0.configuration = .plain()
            $0.configuration?.imagePadding = 4
            $0.configuration?.contentInsets = .zero
        }
           
        myZipButton.do {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.body8,
                withText: "내 족보",
                color: .gray800
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            $0.setImage(.icAddZip, for: .normal)
            $0.configuration = .plain()
            $0.configuration?.imagePadding = 4
            $0.configuration?.contentInsets = .zero
        }
        
        separatorView.do {
            $0.backgroundColor = .gray100
        }
    }
    
}
