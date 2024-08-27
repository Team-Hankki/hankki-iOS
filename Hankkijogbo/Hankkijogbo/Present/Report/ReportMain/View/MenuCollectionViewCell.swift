//
//  MenuCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit

final class MenuCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    private let menuNameMaxLength: Int = 30
    private let priceMaxLength: Int = 5
    weak var delegate: PassItemDataDelegate?
        
    // MARK: - UI Components
    
    private let menuLabel: UILabel = UILabel()
    let menuTextField: UITextField = UITextField()
    private let priceLabel: UILabel = UILabel()
    let priceTextField: UITextField = UITextField()
    private let priceUnitLabel: UILabel = UILabel()
    let deleteMenuButton: UIButton = UIButton()
    private let errorLabel: UILabel = UILabel()
    private let doneToolbar: UIToolbar = UIToolbar()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTextFieldDelegate()
        setupAddTarget()
        setupToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
       setupInitialStyle()
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        contentView.addSubviews(
            menuLabel,
            menuTextField,
            priceLabel,
            priceTextField,
            priceUnitLabel,
            deleteMenuButton,
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
            $0.width.equalTo(UIScreen.convertByWidthRatio(178))
            $0.height.equalTo(48)
        }
        priceTextField.snp.makeConstraints {
            $0.top.equalTo(menuTextField)
            $0.leading.equalTo(menuTextField.snp.trailing).offset(8)
            $0.width.equalTo(UIScreen.convertByWidthRatio(118))
            $0.height.equalTo(menuTextField)
        }
        priceLabel.snp.makeConstraints {
            $0.bottom.equalTo(priceTextField.snp.top).offset(-3)
            $0.leading.equalTo(priceTextField).offset(4)
        }
        priceUnitLabel.snp.makeConstraints {
            $0.trailing.equalTo(priceTextField).offset(-17)
            $0.centerY.equalTo(priceTextField)
        }
        deleteMenuButton.snp.makeConstraints {
            $0.centerY.equalTo(priceTextField)
            $0.trailing.equalToSuperview()
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
                for: PretendardStyle.body6,
                withText: StringLiterals.Report.menuName,
                color: .gray500
            )
        }
        menuTextField.do {
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                color: .gray800
            )
            $0.attributedPlaceholder = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                withText: StringLiterals.Placeholder.menuName,
                color: .gray400
            )
            $0.addPadding(left: 12, right: 12)
        }
        priceLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body6,
                withText: StringLiterals.Report.price,
                color: .gray500
            )
        }
        priceTextField.do {
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                color: .gray800
            )
            $0.attributedPlaceholder = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                withText: StringLiterals.Placeholder.price,
                color: .gray400
            )
            $0.addPadding(left: 12, right: 16)
            $0.keyboardType = .numberPad
            $0.inputAccessoryView = doneToolbar
        }
        priceUnitLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                withText: StringLiterals.Common.won,
                color: .gray800
            )
        }
        deleteMenuButton.do {
            $0.setImage(.btnDeleteSmall, for: .normal)
        }
        errorLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.caption1,
                withText: StringLiterals.Report.priceError,
                color: .red500
            )
            $0.isHidden = true
        }
    }
}

private extension MenuCollectionViewCell {
    
    // MARK: - Private Func
    
    func setupTextFieldDelegate() {
        menuTextField.delegate = self
        priceTextField.delegate = self
    }
    
    func setupAddTarget() {
        priceTextField.addTarget(self, action: #selector(priceTextFieldDidEditingChange), for: .editingChanged)
    }
    
    func setupToolbar() {
        doneToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: StringLiterals.Toolbar.done, style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneButtonDidTap))
        ]
        doneToolbar.sizeToFit()
    }
    
    func setupInitialStyle() {
        menuLabel.textColor = .gray500
        menuTextField.text = ""
        
        priceLabel.textColor = .gray500
        priceTextField.text = ""
        priceTextField.textColor = .gray800
        priceTextField.layer.borderWidth = 1
        priceTextField.layer.borderColor = UIColor.gray300.cgColor
        errorLabel.isHidden = true
    }
    
    func setupPriceErrorStyle() {
        priceLabel.textColor = .red500
        priceTextField.textColor = .red500
        priceTextField.layer.borderWidth = 2
        priceTextField.layer.borderColor = UIColor.red500.cgColor
        errorLabel.isHidden = false
    }
    
    func setupPriceNonErrorStyle() {
        priceLabel.textColor = .gray800
        priceTextField.textColor = .gray800
        
        priceTextField.layer.borderWidth = 2
        priceTextField.layer.borderColor = UIColor.gray400.cgColor
        errorLabel.isHidden = true
    }
    
    // MARK: - @objc Func
    
    @objc func priceTextFieldDidEditingChange() {
        if Int(priceTextField.text ?? "") ?? 0 > 8000 {
            setupPriceErrorStyle()
        } else {
            setupPriceNonErrorStyle()
        }
    }
    
    @objc func doneButtonDidTap() {
        // 숫자 패드 내리기
        self.priceTextField.resignFirstResponder()
    }
}

extension MenuCollectionViewCell {
    
    // MARK: - Public Func
    
    func bindData(menu: MenuData) {
        menuTextField.text = menu.name
        if menu.price != 0 {
            priceTextField.text = "\(menu.price)"
            
            if menu.price > 8000 {
                setupPriceErrorStyle()
            } else {
                setupPriceNonErrorStyle()
            }
        } else {
            priceTextField.text = ""
        }
    }
}

// MARK: - UITextField Delegate

extension MenuCollectionViewCell: UITextFieldDelegate {
    /// 텍스트 필드 내용 수정을 시작할 때 호출되는 함수
    final func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == menuTextField {
            menuLabel.textColor = .gray800
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.gray400.cgColor
        } else {
            priceLabel.textColor = .gray800
            priceTextFieldDidEditingChange()
        }
        return true
    }
    
    final func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        if textField == menuTextField {
            // 메뉴 이름 30자 제한 및 이모지 제한
            return (newString.count <= menuNameMaxLength) && (textField.disableEmojiText(range: range, string: string))
        } else if textField == priceTextField {
            // 가격 5자 제한
            return newString.count <= priceMaxLength
        }
        
        return false
    }
    
    /// 텍스트 필드 내용 수정이 끝났을 때 호출되는 함수
    /// - border 색 원래대로 변경
    /// - 뷰 모델의 메뉴 데이터도 여기서 적힌 값으로 업데이트
    final func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == menuTextField {
            menuLabel.textColor = .gray500
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.gray300.cgColor
        } else {
            if Int(priceTextField.text ?? "") ?? 0 <= 8000 {
                priceLabel.textColor = .gray500
                textField.layer.borderWidth = 1
                textField.layer.borderColor = UIColor.gray300.cgColor
            }
        }
        delegate?.updateViewModelMenusData(cell: self, name: menuTextField.text ?? "", price: (priceTextField.text ?? ""))
    }
    
    /// 키보드의 return 키 클릭 시 호출되는 함수
    /// - 키보드를 내려준다
    final func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
