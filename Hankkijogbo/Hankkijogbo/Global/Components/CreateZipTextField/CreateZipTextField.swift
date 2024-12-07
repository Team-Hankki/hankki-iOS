//
//  CreateZipTextField.swift
//  Hankkijogbo
//
//  Created by 심서현 on 12/6/24.
//

import UIKit

final class CreateZipTextField: BaseView {
    
    // MARK: - Properties
    
    private let type: CreateZipTextFieldType
    
    var value: String {
        didSet {
            countLabel.text = "(\(value.count)/\(type.maxLength))"
            checkIsValid()
        }
    }
    
    typealias IsValid = (() -> Void)
    private let checkIsValid: IsValid
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let textFieldLine = UIView()
    
    private let countView = UIView()
    private let countLabel = UILabel()
    
    // MARK: - Init
    
    init(
        _ type: CreateZipTextFieldType,
        checkIsValid: @escaping IsValid
    ) {
        self.type = type
        self.checkIsValid = checkIsValid
        
        self.value = ""
        
        super.init(frame: .zero)
        
        setupDelegate()
        setupAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 터치 이벤트를 무시하여 드래그를 방지합니다
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if type == .tag {
            if action == #selector(UIResponderStandardEditActions.paste(_:)) {
                return false
            }
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    // MARK: - setup UI
    
    override func setupHierarchy() {
        self.addSubviews(
            titleLabel,
            textField,
            textFieldLine
        )
        countView.addSubview(countLabel)
    }
    
    override func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.top.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.height.equalTo(40)
        }
        
        textFieldLine.snp.makeConstraints {
            $0.horizontalEdges.equalTo(textField)
            $0.top.equalTo(textField.snp.bottom)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
        countView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
    
    override func setupStyle() {
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body6,
                withText: type.titleText,
                color: .gray500
            )
        }
        
        textField.do {
            $0.addPadding(left: 8)
            $0.rightViewMode = type == .title ? .always : .never
            $0.rightView = countView
            
            $0.font = UIFont.setupPretendardStyle(of: .subtitle2)
            $0.textColor = .gray800
            $0.changePlaceholderColor(
                forPlaceHolder: type.placeholderText,
                forColor: .gray300
            )
        }
        
        textFieldLine.do {
            $0.backgroundColor = .gray200
        }
        
        countLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body8,
                withText: "(0/\(type.maxLength))",
                color: .gray300)
        }
    }
}

private extension CreateZipTextField {
    
    func setupDelegate() {
        textField.delegate = self
    }
    
    func setupAddTarget() {
        textField.addTarget(self, action: #selector(updateValue), for: .editingChanged)
    }
}

extension CreateZipTextField {
    // textField를 초기화합니다.
    func resetTextField() {
        textField.text = ""
        value = ""
    }
    
    func setupAccessoryView(_ accessoryView: UIView) {
        textField.inputAccessoryView = accessoryView
    }
}
private extension CreateZipTextField {
    // textField의 값이 바뀔때, value를 업데이트합니다
    @objc func updateValue(_ textField: UITextField) {
        value = textField.text ?? ""
    }
    
    // regex를 기반으로, 정규식에과 일치하는 입력일 경우 true를 반환합니다.
    func isValidString(_ string: String, regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: string)
    }
}

// MARK: - Delegation
extension CreateZipTextField: UITextFieldDelegate {
    
    // textField의 편집을 시작합니다
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldLine.backgroundColor = .gray500
        countLabel.textColor = .gray500
        
        type.textFieldDidBeginEditing(for: self)(textField)
        
        value = textField.text ?? ""
    }
    
    // textField의 편집을 종료합니다
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldLine.backgroundColor = .gray200
        countLabel.textColor = .gray300
        
        // 입력된 text가 maxLength 를 넘기면, text를 maxLength의 길이에 맞게 자릅니다.
        textField.text = String(value.prefix(type.maxLength))
        
        type.textFieldDidEndEditing(for: self)(textField)
        
        value = textField.text ?? ""
    }
    
    // textField의 text의 내용 수정을 감지합니다.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "")
        let updatedText = currentText+string
        
        // 정규식에 맞는 텍스트만 입력되도록 합니다. (+ 스페이스 바, 백스페이스)
        if !isValidString(string, regex: type.regex) && string != " " && !string.isEmpty {
            return false
        }
        
        // TextField의 최대 글자수를 제한 합니다.
        if updatedText.count > type.maxLength + 1 {
            textField.text = String(updatedText.prefix(type.maxLength))
            return false
        }
        
        return type.replaceTextField(for: self)(textField, string, currentText)
    }
    
    // textField에서 선택된 범위가 변경될때 호출됩니다.
    // textField를 드래그 해 선택 범위를 지정하고, 수정을 시작하면
    // endOfDocument를 기준으로 커서를 끝으로 이동시킵니다
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if type == .tag {
            if let endPosition = textField.position(from: textField.endOfDocument, offset: 0) {
                textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
            }
        }
    }
}
