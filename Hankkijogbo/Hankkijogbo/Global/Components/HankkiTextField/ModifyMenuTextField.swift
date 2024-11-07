//
//  ModifyMenuTextField.swift
//  Hankkijogbo
//
//  Created by 서은수 on 11/5/24.
//

import UIKit

protocol ModifyMenuTextFieldDelegate: AnyObject {
    func handleTextFieldUpdate(textField: UITextField)
    func getOriginalText(textField: UITextField) -> String
}

final class ModifyMenuTextField: UITextField {
    
    // MARK: - Properties
    
    var titleText: String
    var placeholderText: String?
    var modifyMenuTextFieldDelegate: ModifyMenuTextFieldDelegate?
    
    private var isModifying: Bool = false
    
    // MARK: - UI Components

    private let titleLabel: UILabel = UILabel()
    private let defaultButton: UIButton = UIButton()
    private let editingButton: UIButton = UIButton()
    private let inputApplyButton: UIButton = UIButton()
    private let inputResetButton: UIButton = UIButton()
    
    // MARK: - Init
    
    init(
        titleText: String,
        placeholderText: String? = nil,
        hankkiTextFieldDelegate: ModifyMenuTextFieldDelegate? = nil
    ) {
        self.titleText = titleText
        self.placeholderText = placeholderText
        self.modifyMenuTextFieldDelegate = hankkiTextFieldDelegate
        super.init(frame: .zero)
        
        setupHierarchy()
        setupLayout()
        setupStyle()
        setupDelegate()
        setupAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ModifyMenuTextField {
    
    // MARK: - Set UI
    
    func setupHierarchy() {
        self.addSubviews(
            titleLabel,
            defaultButton,
            editingButton
        )
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
        
        defaultButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        editingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
    
    func setupStyle() {
        self.do {
            $0.backgroundColor = .hankkiWhite
            $0.layer.cornerRadius = 10
            $0.font = .setupPretendardStyle(of: .body2)
            $0.textColor = .gray850
            $0.attributedPlaceholder = UILabel.setupAttributedText(
                for: PretendardStyle.body2,
                withText: placeholderText ?? "",
                color: .gray400
            )
            $0.textAlignment = .right
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.autocapitalizationType = .none
        }
        
        titleLabel.do {
            $0.font = .setupPretendardStyle(of: .body5)
            $0.textColor = .gray500
            $0.text = titleText
        }
        
        defaultButton.do {
            $0.setImage(.btnModifyMenu, for: .normal)
        }
        
        editingButton.do {
            $0.setImage(.btnDelete, for: .normal)
            $0.isHidden = true
        }
    }
    
    func setupDelegate() {
        delegate = self
    }
    
    func setupAddTarget() {
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        defaultButton.addTarget(self, action: #selector(defaultButtonDidTap), for: .touchUpInside)
        editingButton.addTarget(self, action: #selector(editingButtonDidTap), for: .touchUpInside)
        inputApplyButton.addTarget(self, action: #selector(inputApplyButtonDidTap), for: .touchUpInside)
        inputResetButton.addTarget(self, action: #selector(inputResetButtonDidTap), for: .touchUpInside)
    }
}

private extension ModifyMenuTextField {
    
    func updateStyle(isEditing: Bool) {
        let borderWidth: CGFloat = isEditing ? 1 : 0
        let borderColor: CGColor? = isEditing ? UIColor.gray500.cgColor : nil
        let font: UIFont? = .setupPretendardStyle(of: isEditing ? .body4 : .body5)
        let textColor: UIColor = isEditing ? .gray850 : .gray500
        let hiddenButton: UIButton = isEditing ? defaultButton : editingButton
        let shownButton: UIButton = isEditing ? editingButton : defaultButton

        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
        titleLabel.font = font
        titleLabel.textColor = textColor
        hiddenButton.isHidden = true
        shownButton.isHidden = false
    }
    
    func setupInputAccessoryView() {
        let accessoryView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.getDeviceWidth(), height: 54 + 56))

        inputApplyButton.do {
            $0.backgroundColor = .red400
            $0.setAttributedTitle(
                UILabel.setupAttributedText(
                    for: PretendardStyle.subtitle3,
                    withText: StringLiterals.ModifyMenu.applyButton,
                    color: .hankkiWhite
                ), for: .normal)
        }
        
        inputResetButton.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 8
            $0.setAttributedTitle(
                UILabel.setupAttributedText(
                    for: PretendardStyle.body7,
                    withText: "기존 메뉴\(titleText.suffix(2)) 입력",
                    color: .gray600
                ),
                for: .normal
            )
        }
        
        accessoryView.addSubviews(inputApplyButton, inputResetButton)
        
        inputApplyButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        inputResetButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(inputApplyButton.snp.top).offset(-20)
            $0.width.equalTo(121)
            $0.height.equalTo(36)
        }
        
        inputAccessoryView = accessoryView
    }
    
    func hideInputAccessoryView() {
        inputAccessoryView?.isHidden = true
        inputAccessoryView = nil
    }
    
    // MARK: - @objc Func
    
    @objc func defaultButtonDidTap() {
        isModifying = true
        becomeFirstResponder()
    }
    
    @objc func editingButtonDidTap() {
        text = ""
        modifyMenuTextFieldDelegate?.handleTextFieldUpdate(textField: self)
    }
    
    @objc func inputApplyButtonDidTap() {
        guard let text = text else { return }
        if !text.isEmpty {
            hideInputAccessoryView()
            resignFirstResponder()
        }
    }
    
    @objc func inputResetButtonDidTap() {
        self.text = modifyMenuTextFieldDelegate?.getOriginalText(textField: self)
    }
    
    @objc func textFieldDidChange() {
        guard let text = text else { return }
        inputApplyButton.backgroundColor = !text.isEmpty ? .red500 : .red400
        inputResetButton.isHidden = text.isEmpty
    }
}

// MARK: - UITextFieldDelegate

extension ModifyMenuTextField: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !isModifying { return false }
        
        updateStyle(isEditing: true)
        setupInputAccessoryView()
        textFieldDidChange()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateStyle(isEditing: false)
        hideInputAccessoryView()
        isModifying = false
        modifyMenuTextFieldDelegate?.handleTextFieldUpdate(textField: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideInputAccessoryView()
        resignFirstResponder()
        return true
    }
}
