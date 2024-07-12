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
    let menuDeleteButton = UIButton()
    private let errorLabel = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTextFieldDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        menuTextField.text = ""
        priceTextField.text = ""
        errorLabel.text = ""
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        contentView.addSubviews(
            menuLabel,
            menuTextField,
            priceLabel,
            priceTextField,
            priceUnitLabel,
            menuDeleteButton,
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
        menuDeleteButton.snp.makeConstraints {
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
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                color: .gray800
            )
            $0.addPadding(left: 12, right: 16)
        }
        priceUnitLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                withText: "원",
                color: .gray800
            )
        }
        menuDeleteButton.do {
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
        menuTextField.delegate = self
        priceTextField.delegate = self
    }
}

// MARK: - UITextField Delegate

extension MenuCollectionViewCell: UITextFieldDelegate {
    /// 텍스트 필드 내용 수정을 시작할 때 호출되는 함수
    /// - border 색 검정색으로 변경
    final func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.gray900.cgColor
        return true
    }
    
    /// 가격 5자 제한
    final func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == priceTextField {
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return newString.count <= priceMaxLength
        }
        return true
    }
    
    /// 텍스트 필드 내용 수정이 끝났을 때 호출되는 함수
    /// - border 색 원래대로 변경
    final func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.gray300.cgColor
    }
    
    /// 키보드의 return 키 클릭 시 호출되는 함수
    /// - 키보드를 내려준다
    final func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
