//
//  HankkiMenuHeaderView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiMenuHeaderView: BaseCollectionReusableView {
 
    // MARK: - UI Components
    
    private let menuLabel: UILabel = UILabel()
    private let menuNumberLabel: UILabel = UILabel()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubviews(menuLabel, menuNumberLabel)
    }
    
    override func setupLayout() {
        menuLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(22)
        }
        
        menuNumberLabel.snp.makeConstraints {
            $0.centerY.equalTo(menuLabel)
            $0.leading.equalTo(menuLabel.snp.trailing).offset(3)
        }
    }
    
    override func setupStyle() {
        menuLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle2,
                withText: StringLiterals.HankkiDetail.menu,
                color: .gray900
            )
        }
        
        menuNumberLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle2,
                color: .red500
            )
        }
    }
}

extension HankkiMenuHeaderView {
    
    func bindData(menuNumber: String) {
        menuNumberLabel.text = menuNumber
    }
}
