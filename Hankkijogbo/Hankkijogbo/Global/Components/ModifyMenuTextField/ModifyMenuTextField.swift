//
//  ModifyMenuTextField.swift
//  Hankkijogbo
//
//  Created by 서은수 on 11/5/24.
//

import UIKit

protocol ModifyMenuTextFieldDelegate: AnyObject {
    func updateModifiedMenuData(textField: UITextField)
    func updateErrorLabelVisibility(isHidden: Bool)
    func showDeleteAlert()
    func showModifyCompleteAlert()
}

final class ModifyMenuTextField: UITextField {
    
    // MARK: - Properties
    
    var titleText: String
    var originalText: String?
    var placeholderText: String?
    var modifyMenuTextFieldDelegate: ModifyMenuTextFieldDelegate?
    
    private let menuNameMaxLength: Int = 30
    
    private lazy var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(modifyButtonDidTap))

    // MARK: - UI Components
    
    private let titleLabel: UILabel = UILabel()
    private let modifyButton: UIButton = UIButton()
    private let xButton: UIButton = UIButton()
    
    lazy var enterMenuAccessoryView: EnterMenuAccessoryView = EnterMenuAccessoryView(titleText: titleText)
    private lazy var deleteMenuAccessoryView: DeleteMenuAccessoryView = DeleteMenuAccessoryView(
        deleteButtonAction: showDeleteAlert,
        xButtonAction: hideDeleteMenuAccessoryView
    )
    
    // MARK: - Init
    
    init(
        titleText: String,
        originalText: String? = nil,
        placeholderText: String? = nil,
        modifyMenuTextFieldDelegate: ModifyMenuTextFieldDelegate? = nil
    ) {
        self.titleText = titleText
        self.originalText = originalText
        self.placeholderText = placeholderText
        self.modifyMenuTextFieldDelegate = modifyMenuTextFieldDelegate
        super.init(frame: .zero)
        self.text = originalText

        setupHierarchy()
        setupLayout()
        setupStyle()
        setupDelegate()
        setupAddTarget()
        setupGesture()
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
            modifyButton,
            xButton
        )
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
        
        modifyButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        xButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
    
    func setupStyle() {
        self.do {
            $0.backgroundColor = .hankkiWhite
            $0.layer.cornerRadius = 10
            $0.font = .setupPretendardStyle(of: .body3)
            $0.textColor = .gray800
            $0.attributedPlaceholder = UILabel.setupAttributedText(
                for: PretendardStyle.body3,
                withText: placeholderText ?? "",
                color: .gray400
            )
            $0.textAlignment = .right
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.autocapitalizationType = .none
        }
        
        titleLabel.do {
            $0.font = .setupPretendardStyle(of: .body6)
            $0.textColor = .gray500
            $0.text = titleText
        }
        
        modifyButton.do {
            $0.setImage(.btnModifyMenu, for: .normal)
        }
        
        xButton.do {
            $0.setImage(.btnDelete, for: .normal)
            $0.isHidden = true
        }
    }
    
    func setupDelegate() {
        delegate = self
    }
    
    func setupAddTarget() {
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        modifyButton.addTarget(self, action: #selector(modifyButtonDidTap), for: .touchUpInside)
        xButton.addTarget(self, action: #selector(xButtonDidTap), for: .touchUpInside)
        enterMenuAccessoryView.hankkiAccessoryView.button.addTarget(self, action: #selector(modifyCompleteButtonDidTap), for: .touchUpInside)
        enterMenuAccessoryView.resetButton.addTarget(self, action: #selector(inputResetButtonDidTap), for: .touchUpInside)
    }
    
    func setupGesture() {
        addGestureRecognizer(tapGesture)
    }
}

private extension ModifyMenuTextField {
    
    func setupInputAccessoryView() {
        let accessoryView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.getDeviceWidth(), height: 54 + 56))
        accessoryView.addSubviews(enterMenuAccessoryView, deleteMenuAccessoryView)
        
        enterMenuAccessoryView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(54 + 56)
        }
        
        deleteMenuAccessoryView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(73)
        }
        
        inputAccessoryView = accessoryView
    }
    
    func updateButtonBy(isFocus: Bool) {
        modifyButton.isHidden = isFocus
        xButton.isHidden = !isFocus
    }
    
    func updateStyleBy(isFocus: Bool) {
        textColor = isFocus ? .gray850 : .gray800
        layer.borderWidth = isFocus ? 1 : 0
        layer.borderColor = isFocus ? UIColor.gray500.cgColor : nil
        titleLabel.font = .setupPretendardStyle(of: isFocus ? .body5 : .body6)
        titleLabel.textColor = isFocus ? .gray850 : .gray500
        
        updateButtonBy(isFocus: isFocus)
        modifyMenuTextFieldDelegate?.updateErrorLabelVisibility(isHidden: true)
    }
    
    func updateErrorStyleBy(isFocus: Bool) {
        textColor = .warnRed
        if isFocus {
            layer.borderColor = UIColor.warnRed.cgColor
        } else {
            titleLabel.textColor = .warnRed
        }
        
        modifyMenuTextFieldDelegate?.updateErrorLabelVisibility(isHidden: !isFocus)
    }
    
    func updateStyle(type: ModifyMenuTextFieldType) {
        switch type {
        case .focused:
            updateStyleBy(isFocus: true)
            toggleAccessoryViewVisibility(isDeleteHidden: true)
        case .unfocused:
            updateStyleBy(isFocus: false)
        case .focusedWithError:
            updateStyleBy(isFocus: true)
            updateErrorStyleBy(isFocus: true)
            toggleAccessoryViewVisibility(isDeleteHidden: false)
        case .unfocusedWithError:
            updateStyleBy(isFocus: false)
            updateErrorStyleBy(isFocus: false)
        }
    }
    
    func isErrorValue() -> Bool {
        guard let price = Int(text ?? "") else { return false }
        return titleText == StringLiterals.ModifyMenu.price && price > 8000
    }
    
    func toggleAccessoryViewVisibility(isDeleteHidden: Bool) {
        deleteMenuAccessoryView.isHidden = isDeleteHidden
        enterMenuAccessoryView.isHidden = !isDeleteHidden
    }
    
    func hideDeleteMenuAccessoryView() {
        toggleAccessoryViewVisibility(isDeleteHidden: true)
    }
    
    func showDeleteAlert() {
        modifyMenuTextFieldDelegate?.showDeleteAlert()
    }
        
    func modifyComplete() {
        modifyMenuTextFieldDelegate?.updateModifiedMenuData(textField: self)
        modifyMenuTextFieldDelegate?.showModifyCompleteAlert()
    }
    
    // MARK: - @objc Func
    
    @objc func modifyButtonDidTap() {
        becomeFirstResponder()
    }
    
    @objc func xButtonDidTap() {
        text = ""
        updateStyle(type: .unfocused)
        modifyMenuTextFieldDelegate?.updateModifiedMenuData(textField: self)
    }
    
    @objc func modifyCompleteButtonDidTap() {
        guard let text = text else { return }
        if !text.isEmpty {
            modifyComplete()
        }
    }
    
    @objc func inputResetButtonDidTap() {
        self.text = originalText
        textFieldDidChange()
    }
    
    @objc func textFieldDidChange() {
        guard let text = text, let modifyMenuTextFieldDelegate = modifyMenuTextFieldDelegate else { return }
        modifyMenuTextFieldDelegate.updateModifiedMenuData(textField: self)
        enterMenuAccessoryView.resetButton.isHidden = (text == originalText)
        
        updateStyle(type: isErrorValue() ? .focusedWithError : .focused)
    }
}

// MARK: - UITextFieldDelegate

extension ModifyMenuTextField: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setupInputAccessoryView()
        textFieldDidChange()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        if titleText == StringLiterals.ModifyMenu.name {
            return (newString.count <= menuNameMaxLength) && (textField.disableEmojiText(range: range, string: string))
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateStyle(type: isErrorValue() ? .unfocusedWithError : .unfocused)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateStyle(type: .unfocused)
        resignFirstResponder()
        
        return true
    }
}
