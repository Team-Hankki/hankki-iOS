//
//  HankkiTextField.swift
//  Hankkijogbo
//
//  Created by 서은수 on 11/5/24.
//

import UIKit

protocol HankkiTextFieldDelegate: AnyObject {
    func handleTextFieldUpdate(textField: UITextField)
}

final class HankkiTextField: UITextField {
    
    // MARK: - Properties
    
    var titleText: String
    var placeholderText: String?
    var inputAccessoryText: String?
    var defaultButtonImage: UIImage
    var editingButtonImage: UIImage
    var defaultButtonHandler: (() -> Void)?
    var editingButtonHandler: (() -> Void)?
    var hankkiTextFieldDelegate: HankkiTextFieldDelegate?
    
    private var isModifying: Bool = false
    
    // MARK: - UI Components

    private let titleLabel: UILabel = UILabel()
    private let rightButton: UIButton = UIButton()
    private let inputAccessoryButton: UIButton = UIButton()
    
    // MARK: - Init
    
    init(
        titleText: String,
        placeholderText: String? = nil,
        inputAccessoryText: String? = nil,
        defaultButtonImage: UIImage,
        editingButtonImage: UIImage,
        defaultButtonHandler: (() -> Void)? = nil,
        editingButtonHandler: (() -> Void)? = nil,
        hankkiTextFieldDelegate: HankkiTextFieldDelegate? = nil
    ) {
        self.titleText = titleText
        self.placeholderText = placeholderText
        self.inputAccessoryText = inputAccessoryText
        self.defaultButtonImage = defaultButtonImage
        self.editingButtonImage = editingButtonImage
        self.defaultButtonHandler = defaultButtonHandler
        self.editingButtonHandler = editingButtonHandler
        self.hankkiTextFieldDelegate = hankkiTextFieldDelegate
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

private extension HankkiTextField {
    
    // MARK: - Set UI
    
    func setupHierarchy() {
        self.addSubviews(
            titleLabel,
            rightButton
        )
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
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
        
        rightButton.do {
            $0.setImage(defaultButtonImage, for: .normal)
            $0.addTarget(self, action: #selector(rightButtonDidTap), for: .touchUpInside)
        }
    }
    
    func setupDelegate() {
        delegate = self
    }
    
    func setupAddTarget() {
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        inputAccessoryButton.addTarget(self, action: #selector(applyButtonDidTap), for: .touchUpInside)
    }
}

private extension HankkiTextField {
    
    func updateStyle(isEditing: Bool) {
        let borderWidth: CGFloat = isEditing ? 1 : 0
        let borderColor: CGColor? = isEditing ? UIColor.gray500.cgColor : nil
        let font: UIFont? = .setupPretendardStyle(of: isEditing ? .body4 : .body5)
        let textColor: UIColor = isEditing ? .gray850 : .gray500
        let buttonImage: UIImage = isEditing ? editingButtonImage : defaultButtonImage

        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
        titleLabel.font = font
        titleLabel.textColor = textColor
        rightButton.setImage(buttonImage, for: .normal)
    }
    
    func setupInputAccessoryView() {
        guard let inputAccessoryText = inputAccessoryText else { return }
        
        inputAccessoryButton.do {
            $0.frame = .init(x: 0, y: 0, width: UIScreen.getDeviceWidth(), height: 54)
            $0.backgroundColor = .red400
            $0.setAttributedTitle(
                UILabel.setupAttributedText(
                    for: PretendardStyle.subtitle3,
                    withText: inputAccessoryText,
                    color: .hankkiWhite
                ), for: .normal)
        }
        
        inputAccessoryView = inputAccessoryButton
    }
    
    func hideInputAccessoryView() {
        inputAccessoryButton.backgroundColor = .clear
        inputAccessoryView = nil
    }
    
    // MARK: - @objc Func
    
    @objc func rightButtonDidTap() {
        defaultButtonHandler?()
        isModifying = true
        becomeFirstResponder()
    }
    
    @objc func applyButtonDidTap() {
        guard let text = text else { return }
        if !text.isEmpty {
            hideInputAccessoryView()
            resignFirstResponder()
        }
    }
    
    @objc func textFieldDidChange() {
        guard let text = text else { return }
        inputAccessoryButton.backgroundColor = !text.isEmpty ? .red500 : .red400
    }
}

// MARK: - UITextFieldDelegate

extension HankkiTextField: UITextFieldDelegate {
    
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
        
        hankkiTextFieldDelegate?.handleTextFieldUpdate(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideInputAccessoryView()
        resignFirstResponder()
        return true
    }
}
