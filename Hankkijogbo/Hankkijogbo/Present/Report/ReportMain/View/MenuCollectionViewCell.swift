//
//  MenuCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit

final class MenuCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    private let priceMaxLength = 5
        
    // MARK: - UI Properties
    
    private let menuLabel = UILabel()
    private let menuTextField = UITextField()
    private let priceLabel = UILabel()
    private let priceTextField = UITextField()
    private let priceUnitLabel = UILabel()
    private let xButton = UIButton()
    private let errorLabel = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTextFieldDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        contentView.addSubviews(
            menuLabel,
            menuTextField,
            priceLabel,
            priceTextField,
            priceUnitLabel,
            xButton,
            errorLabel
        )
    }
    
    override func setupLayout() {
        menuLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
        }
        menuTextField.snp.makeConstraints {
            $0.top.equalTo(menuLabel.snp.bottom).offset(3)
            $0.leading.equalToSuperview()
            $0.width.equalTo(178)
            $0.height.equalTo(48)
        }
        priceTextField.snp.makeConstraints {
            $0.top.equalTo(menuTextField)
            $0.leading.equalTo(menuTextField.snp.trailing).offset(8)
            $0.width.equalTo(118)
            $0.height.equalTo(menuTextField)
        }
        priceLabel.snp.makeConstraints {
            $0.bottom.equalTo(priceTextField.snp.top).offset(-3)
            $0.leading.equalTo(priceTextField).offset(4)
        }
        priceUnitLabel.snp.makeConstraints {
            $0.trailing.equalTo(priceTextField).offset(-17)
            $0.centerY.equalTo(priceTextField).offset(2)
        }
        xButton.snp.makeConstraints {
            $0.centerY.equalTo(priceTextField)
            $0.leading.equalTo(priceTextField.snp.trailing).offset(3)          
            $0.size.equalTo(32)
        }
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(priceTextField.snp.bottom).offset(6)
            $0.leading.equalTo(priceLabel)
        }
    }
    
    override func setupStyle() {
        menuLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body5,
                withText: "메뉴 이름",
                color: .gray500
            )
        }
        menuTextField.do {
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 10
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                withText: "",
                color: .gray800
            )
            $0.addPadding(left: 12, right: 12)
        }
        priceLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body5,
                withText: "가격",
                color: .hankkiRed
            )
        }
        priceTextField.do {
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.hankkiRed.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 10
            $0.font = .setupPretendardStyle(of: .body1)
            $0.textColor = .gray800
            $0.addPadding(left: 12, right: 16)
        }
        priceUnitLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                withText: "원",
                color: .gray800
            )
        }
        xButton.do {
            $0.setImage(.icClose, for: .normal)
        }
        errorLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.caption1,
                withText: "8000원 이하만 가능해요",
                color: .hankkiRed
            )
        }
    }
}

private extension MenuCollectionViewCell {
    
    // MARK: - Private Func
    
    func setupTextFieldDelegate() {
        priceTextField.delegate = self
    }
}

// MARK: - UITextFieldDelegate

extension MenuCollectionViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= priceMaxLength
    }
}
