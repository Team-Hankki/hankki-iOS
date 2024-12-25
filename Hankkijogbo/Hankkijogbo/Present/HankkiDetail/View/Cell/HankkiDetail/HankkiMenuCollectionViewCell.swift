//
//  HankkiMenuCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiMenuCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    // MARK: - UI Components
    
    private var nameLabel: UILabel = UILabel()
    private let priceLabel: UILabel = UILabel()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubviews(nameLabel, priceLabel)
    }
    
    override func setupLayout() {
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(22)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nameLabel)
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.backgroundColor = .hankkiWhite
        }
        
        nameLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body8,
                color: .gray900
            )
            $0.numberOfLines = 0
        }
        
        priceLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body5,
                color: .gray850
            )
        }
    }
}

extension HankkiMenuCollectionViewCell {
    
    func bindData(_ menuData: MenuData) {
        nameLabel.text = menuData.name
        priceLabel.formattingPrice(price: menuData.price)
    }
}
