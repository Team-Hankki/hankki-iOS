//
//  HankkiDetailCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiDetailCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Properties
    
    private var hankkiMenuNameLabel: UILabel = UILabel()
    private let separatorView: UIView = UIView()
    private let hankkiMenuPriceLabel: UILabel = UILabel()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubviews(
            hankkiMenuNameLabel,
            separatorView,
            hankkiMenuPriceLabel
        )
    }
    
    override func setupLayout() {
        hankkiMenuNameLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        separatorView.snp.makeConstraints {
            $0.leading.equalTo(hankkiMenuNameLabel.snp.trailing).offset(27)
            $0.trailing.equalTo(hankkiMenuPriceLabel.snp.leading).offset(-27)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(2)
        }
        hankkiMenuPriceLabel.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        hankkiMenuNameLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                color: .gray700
            )
        }
        separatorView.do {
            $0.backgroundColor = .gray100
        }
        hankkiMenuPriceLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                color: .gray500
            )
        }
    }
}

extension HankkiDetailCollectionViewCell {
    func bindMenuData(_ menuData: MenuData) {
        hankkiMenuNameLabel.text = menuData.name
        hankkiMenuPriceLabel.text = "\(menuData.price)\(StringLiterals.Common.won)"
    }
}
