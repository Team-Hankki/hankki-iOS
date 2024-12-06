//
//  CreateZipTextField.swift
//  Hankkijogbo
//
//  Created by 심서현 on 12/6/24.
//

import UIKit

final class CreateZipTextField: UIView {
    
    // MARK: - Properties
    
    private let titleText: String
    private let placeholderText: String
    private let maxLength: Int
    private let regex: String
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let textFieldLine = UIView()
    
    // MARK: - Init
    
    init(
        titleText: String,
        placeholderText: String,
        maxLength: Int,
        regex: String
    ) {
        self.titleText = titleText
        self.placeholderText = placeholderText
        self.maxLength = maxLength
        self.regex = regex
        
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

private extension CreateZipTextField {
    func setupHierarchy() {
        self.addSubviews(
            titleLabel,
            textField,
            textFieldLine
        )
    }
    
    func setupLayout() {
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
    }
    
    func setupStyle() {
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body6,
                withText: titleText,
                color: .gray500
            )
        }
        
        textField.do {
            $0.addPadding(left: 8)
            
            $0.font = UIFont.setupPretendardStyle(of: .subtitle2)
            $0.textColor = .gray800
            $0.changePlaceholderColor(
                forPlaceHolder: placeholderText,
                forColor: .gray300
            )
        }
        
        textFieldLine.do {
            $0.backgroundColor = .gray200
        }
    }
    
    func setupDelegate() {
        textField.delegate = self
    }
}

private extension CreateZipTextField {
    // regex를 기반으로, 정규식에과 일치하는 입력일 경우 true를 반환합니다.
    func isValidString(_ s: String, regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: s)
    }
}

extension CreateZipTextField: UITextFieldDelegate {
    
    // textField의 편집을 시작합니다
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldLine.backgroundColor = .gray500
    }
    
    // textField의 편집을 종료합니다
    func textFieldDidEndEditing(_ textField: UITextField) {
        let currentText = textField.text ?? ""
        
        textFieldLine.backgroundColor = .gray200
        textField.text = String(currentText.prefix(maxLength))
    }
    
    // textField의 text의 내용 수정을 감지합니다.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "")
        let updatedText = currentText+string
        
        // 정규식에 맞는 텍스트만 입력되도록 합니다. (+ 스페이스 바, 백스페이스)
        if !isValidString(string, regex: regex) && string != " " && !string.isEmpty {
            return false
        }
        
        // TextField의 최대 글자수를 제한 합니다.
        if updatedText.count > maxLength + 1 {
            textField.text = String(updatedText.prefix(maxLength))
            return false
        }
        return true
    }
}
