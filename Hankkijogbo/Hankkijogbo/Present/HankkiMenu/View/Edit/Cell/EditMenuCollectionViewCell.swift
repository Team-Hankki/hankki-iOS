//
//  EditMenuCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/10/24.
//

import UIKit

final class EditMenuCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Components
    
    var radioButton: RadioButton = RadioButton()
    private var nameLabel: UILabel = UILabel()
    private let priceLabel: UILabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupStyle()
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        contentView.addSubviews(
            radioButton,
            nameLabel,
            priceLabel
        )
    }
    
    override func setupLayout() {
        radioButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(radioButton.snp.trailing).offset(13)
            $0.centerY.equalTo(radioButton)
            $0.width.lessThanOrEqualTo(UIScreen.getDeviceWidth() - 60 - 13 - 55 - 24)
        }
        priceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalTo(nameLabel)
        }
    }
    
    override func setupStyle() {
        nameLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body3,
                color: .gray700
            )
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        priceLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body3,
                color: .gray700
            )
        }
        radioButton.do {
            $0.isUserInteractionEnabled = false
        }
    }
    
    func updateStyle(isSelected: Bool) {
        backgroundColor = isSelected ? .red100 : .hankkiWhite
        radioButton.setImage(isSelected ? .btnRadioSelected : .btnRadioNormal, for: .normal)
        
        let font: UIFont? = .setupPretendardStyle(of: isSelected ? .body2 : .body3)
        let textColor: UIColor = isSelected ? .red500 : .gray700
        nameLabel.font = font
        priceLabel.font = font
        nameLabel.textColor = textColor
        priceLabel.textColor = textColor
    }
    
    func updateDefaultStyle() {
        backgroundColor = .hankkiWhite
        nameLabel.font = .setupPretendardStyle(of: .body3)
        priceLabel.font = .setupPretendardStyle(of: .body3)
        nameLabel.textColor = .gray700
        priceLabel.textColor = .gray700
        radioButton.setImage(.btnRadioNormal, for: .normal)
    }
}

extension EditMenuCollectionViewCell {
    
    func bindData(_ menuData: SelectableMenuData) {
        nameLabel.text = menuData.name
        priceLabel.formattingPrice(price: menuData.price)
        updateStyle(isSelected: menuData.isSelected)
    }
}
