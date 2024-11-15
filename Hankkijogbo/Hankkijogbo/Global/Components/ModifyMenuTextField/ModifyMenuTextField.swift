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
    func isMenuDataValid() -> Bool
    func showErrorLabel(isWarn: Bool)
    func showDeleteAlert()
    func showModifyCompleteAlert()
}

final class ModifyMenuTextField: UITextField {
    
    // MARK: - Properties
    
    var titleText: String
    var originalText: String = ""
    var placeholderText: String?
    var modifyMenuTextFieldDelegate: ModifyMenuTextFieldDelegate?
    
    private var isModifying: Bool = false {
        didSet {
            updateStyle()
            modifyMenuTextFieldDelegate?.showErrorLabel(isWarn: isWarn && isModifying)
        }
    }
    private var isWarn: Bool = false {
        didSet {
            updateStyle()
            toggleAccessoryViewVisibility(isDeleteHidden: !isWarn)
            modifyMenuTextFieldDelegate?.showErrorLabel(isWarn: isWarn && isModifying)
        }
    }
    
    private lazy var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(modifyButtonDidTap))

    // MARK: - UI Components
    
    private let titleLabel: UILabel = UILabel()
    private let modifyButton: UIButton = UIButton()
    private let xButton: UIButton = UIButton()
    private lazy var enterMenuAccessoryView: EnterMenuAccessoryView = EnterMenuAccessoryView(titleText: titleText)
    private lazy var deleteMenuAccessoryView: DeleteMenuAccessoryView = DeleteMenuAccessoryView(
        deleteButtonAction: showDeleteAlert,
        xButtonAction: hideDeleteMenuAccessoryView
    )
    
    // MARK: - Init
    
    init(
        titleText: String,
        originalText: String,
        placeholderText: String? = nil,
        hankkiTextFieldDelegate: ModifyMenuTextFieldDelegate? = nil
    ) {
        self.titleText = titleText
        self.placeholderText = placeholderText
        self.modifyMenuTextFieldDelegate = hankkiTextFieldDelegate
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
        enterMenuAccessoryView.modifyCompleteButton.addTarget(self, action: #selector(modifyCompleteButtonDidTap), for: .touchUpInside)
        enterMenuAccessoryView.resetButton.addTarget(self, action: #selector(inputResetButtonDidTap), for: .touchUpInside)
    }
    
    func setupGesture() {
        addGestureRecognizer(tapGesture)
    }
}

private extension ModifyMenuTextField {
    
    func updateStyle() {
        if isWarn && titleText == StringLiterals.ModifyMenu.price {
            updateWarnStyle()
        } else {
            let textColor: UIColor = isModifying ? .gray850 : .gray800
            let borderWidth: CGFloat = isModifying ? 1 : 0
            let borderColor: CGColor? = isModifying ? UIColor.gray500.cgColor : nil
            let titleFont: UIFont? = .setupPretendardStyle(of: isModifying ? .body5 : .body6)
            let titleTextColor: UIColor = isModifying ? .gray850 : .gray500
            
            self.textColor = textColor
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor
            titleLabel.font = titleFont
            titleLabel.textColor = titleTextColor
        }
        
        let hiddenButton: UIButton = isModifying ? modifyButton : xButton
        let shownButton: UIButton = isModifying ? xButton : modifyButton
        hiddenButton.isHidden = true
        shownButton.isHidden = false
    }
    
    func updateWarnStyle() {
        if let text = text, text.isEmpty { isWarn = false }
        titleLabel.textColor = isWarn && !isModifying ? .warnRed : .gray850
        layer.borderWidth = isWarn && isModifying ? 1 : 0
        layer.borderColor = isWarn && isModifying ? UIColor.warnRed.cgColor : nil
        textColor = isWarn ? .warnRed : .gray850
    }
    
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
        modifyMenuTextFieldDelegate?.handleTextFieldUpdate(textField: self)
        modifyMenuTextFieldDelegate?.showModifyCompleteAlert()
    }
    
    // MARK: - @objc Func
    
    @objc func modifyButtonDidTap() {
        becomeFirstResponder()
    }
    
    @objc func xButtonDidTap() {
        isWarn = false
        isModifying = false
        text = ""
        modifyMenuTextFieldDelegate?.handleTextFieldUpdate(textField: self)
    }
    
    @objc func modifyCompleteButtonDidTap() {
        guard let text = text else { return }
        if !text.isEmpty {
            modifyComplete()
        }
    }
    
    @objc func inputResetButtonDidTap() {
        self.text = modifyMenuTextFieldDelegate?.getOriginalText(textField: self)
    }
    
    @objc func textFieldDidChange() {
        guard let text = text, let modifyMenuTextFieldDelegate = modifyMenuTextFieldDelegate else { return }
        modifyMenuTextFieldDelegate.handleTextFieldUpdate(textField: self)
        enterMenuAccessoryView.modifyCompleteButton.backgroundColor = modifyMenuTextFieldDelegate.isMenuDataValid() ? .red500 : .red400
        enterMenuAccessoryView.resetButton.isHidden = text.isEmpty
        
        if titleText == StringLiterals.ModifyMenu.price, let price = Int(text) {
            isWarn = price > 8000
        }
    }
}

// MARK: - UITextFieldDelegate

extension ModifyMenuTextField: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isModifying = true
        setupInputAccessoryView()
        textFieldDidChange()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isModifying = false
    }
}
