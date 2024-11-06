//
//  HankkiTextField.swift
//  Hankkijogbo
//
//  Created by 서은수 on 11/5/24.
//

import UIKit

final class HankkiTextField: UITextField {
    
    // MARK: - Properties
    
    var titleText: String
    var placeholderText: String?
    var defaultButtonImage: UIImage
    var editingButtonImage: UIImage
    
    // MARK: - UI Components

    private let titleLabel: UILabel = UILabel()
    private let rightButton: UIButton = UIButton()
    
    // MARK: - Init
    
    init(
        titleText: String,
        placeholderText: String? = nil,
        defaultButtonImage: UIImage,
        editingButtonImage: UIImage
    ) {
        self.titleText = titleText
        self.placeholderText = placeholderText
        self.defaultButtonImage = defaultButtonImage
        self.editingButtonImage = editingButtonImage
        super.init(frame: .zero)
        
        setupHierarchy()
        setupLayout()
        setupStyle()
        setupDelegate()
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
                withText: StringLiterals.ModifyMenu.namePlaceholder,
                color: .gray400
            )
            $0.addPadding(left: 73, right: 44)
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
    
    // MARK: - @objc Func
    
    @objc func rightButtonDidTap() {
        becomeFirstResponder()
    }
}

// MARK: - UITextFieldDelegate

extension HankkiTextField: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        updateStyle(isEditing: true)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateStyle(isEditing: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
