//
//  EditMenuCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/10/24.
//

import UIKit

final class EditMenuCollectionViewCell: BaseCollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            isSelected ? updateSelectedStyle() : updateDefaultStyle()
        }
    }
    
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
        }
        priceLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body3,
                color: .gray700
            )
        }
    }
    
    func updateSelectedStyle() {
        backgroundColor = .red100
        nameLabel.font = .setupPretendardStyle(of: .body2)
        priceLabel.font = .setupPretendardStyle(of: .body2)
        nameLabel.textColor = .red500
        priceLabel.textColor = .red500
        radioButton.setImage(.btnRadioSelected, for: .normal)
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
    func bindData(_ menuData: MenuData) {
        nameLabel.text = menuData.name
        priceLabel.formattingPrice(price: menuData.price)
    }
}
