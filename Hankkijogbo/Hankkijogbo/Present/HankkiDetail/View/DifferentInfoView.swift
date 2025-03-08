//
//  DifferentInfoView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 12/19/24.
//

import UIKit

final class DifferentInfoView: BaseView {
    
    // MARK: - UI Components
    
    private let homeImageView: UIImageView = UIImageView()
    private let textLabel: UILabel = UILabel()
    private let rightArrowImageView: UIImageView = UIImageView()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubviews(homeImageView, textLabel, rightArrowImageView)
    }
    
    override func setupLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(180)
            $0.height.equalTo(29)
        }
        
        homeImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }
        
        textLabel.snp.makeConstraints {
            $0.leading.equalTo(homeImageView.snp.trailing).offset(4)
            $0.centerY.equalTo(homeImageView)
        }
        
        rightArrowImageView.snp.makeConstraints {
            $0.leading.equalTo(textLabel.snp.trailing).offset(2)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.layer.cornerRadius = 29 / 2
            $0.backgroundColor = .hankkiWhite
            $0.addShadow(alpha: 0.12, y: 3, blur: 10)
        }
        
        homeImageView.do {
            $0.image = .icHomeSelected
        }
        
        textLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.caption5,
                                                            withText: StringLiterals.HankkiDetail.reportDifferentInformation,
                                                            color: .gray800)
        }
        
        rightArrowImageView.do {
            $0.image = .icArrowRight
        }
    }
}
