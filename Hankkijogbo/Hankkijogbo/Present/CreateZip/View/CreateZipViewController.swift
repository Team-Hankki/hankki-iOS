//
//  CreateZipViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/11/24.
//

import UIKit

final class CreateZipViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let tagMaxCount: Int = 9
    
    private var firstTagCount: Int = 0
    
    // MARK: - UI Properties
    
    private let viewTitle = UILabel()
    
    private let titleInputTitle = UILabel()
    private let titleInputTextField = UITextField()
    private let titleCountView = UIView()
    private let titleCountLabel = UILabel()
    
    private let tagInputTitle = UILabel()
    private let tagInputTextField = TagTextField()
    
    private let submmitButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupAction()
    }
    
    // MARK: - Set UI
    
    override func setupStyle() {
        viewTitle.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.h1, 
                                                            withText: "새로운 식당 족보", 
                                                            color: .gray900)
        }
        
        titleInputTitle.do {
            $0.attributedText = UILabel.setupAttributedText(for: SuiteStyle.body1,
                                                            withText: "족보의 제목을 지어주세요",
                                                            color: .gray900)
        }
    
        titleInputTextField.do {
            $0.tag = 0
            $0.makeRounded(radius: 10)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.addPadding(left: 12, right: 14)
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body1, color: .gray900)
            $0.changePlaceholderColor(forPlaceHolder: "성대생 추천 맛집 알려주세요", forColor: .gray400)
            $0.rightViewMode = .always
            $0.rightView = titleCountView
        }
        
        titleCountLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body3,
                                                            withText: "(0/18)",
                                                            color: .gray300)
        }
        
        tagInputTitle.do {
            $0.attributedText = UILabel.setupAttributedText(for: SuiteStyle.body1,
                                                            withText: "족보를 떠올리면?",
                                                            color: .gray900)
        }
        
        tagInputTextField.do {
            $0.tag = 1
            $0.makeRounded(radius: 10)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.addPadding(left: 12)
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body1, color: .gray900)
            $0.placeholder = "#든든한 #한끼해장"
            $0.changePlaceholderColor(forPlaceHolder: "#든든한 #한끼해장", forColor: .gray400)
        }
        
        submmitButton.do {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: "족보 만들기",
                color: .hankkiWhite
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            $0.backgroundColor = .hankkiRedLight2
            $0.makeRounded(radius: 16)
            $0.isEnabled = true
        }
    }
    
    override func setupHierarchy() {
        view.addSubviews(
            viewTitle,
            titleInputTitle, 
            titleInputTextField, 
            tagInputTitle,
            tagInputTextField,
            submmitButton
          )
        titleCountView.addSubview(titleCountLabel)
    }
    
    override func setupLayout() {
        viewTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(75)
        }
        
        titleInputTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22)
            $0.top.equalTo(viewTitle.snp.bottom).offset(58)
        }
        
        titleInputTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.top.equalTo(titleInputTitle.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        
        tagInputTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22)
            $0.top.equalTo(titleInputTextField.snp.bottom).offset(30)
        }
        
        tagInputTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.top.equalTo(tagInputTitle.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        
        titleCountView.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(50)
        }
        titleCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
        }
        submmitButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tagInputTextField.snp.bottom).offset(37)
            $0.height.equalTo(54)
            $0.width.equalTo(149)
        }
    }
}

private extension CreateZipViewController {
    func setupDelegate() {
        titleInputTextField.delegate = self
        tagInputTextField.delegate = self
    }
    
    func setupAction() {
        titleInputTextField.addTarget(self, action: #selector(titleTextFieldDidChange), for: .editingChanged)
        submmitButton.addTarget(self, action: #selector(submmitButtonDidTap), for: .touchUpInside)
    }

    @objc func titleTextFieldDidChange(_ textField: UITextField) {
        let currentText = textField.text ?? ""
        if currentText.count <= 18 { titleCountLabel.text = "(\(currentText.count)/18)" }
    }
    
    @objc func submmitButtonDidTap() {
        let arr = (tagInputTextField.text ?? "").split(separator: " ")
        self.showAlert(titleText: "제출 확인용 테스트 모달입니다.", 
                       subText: "\(titleInputTextField.text ?? " ") \n \(arr)",
                       primaryButtonText: "돌아가기")
    }
}

// MARK: - delegate
extension CreateZipViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 0 { titleCountLabel.textColor = .gray500 }
        
        if textField.tag == 1 {
            let currentText = textField.text ?? ""
            if currentText.isEmpty {
                textField.text = "#"
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.gray200.cgColor
        
        let currentText = textField.text ?? ""
        
        if textField.tag == 0 {
            titleInputTextField.text = String(currentText.prefix(18))
            return
        }
        titleCountLabel.textColor = .gray200
    
        print(currentText, currentText.count)
        if currentText.count <= 1 {
            textField.text = ""
            return
        }
        
        if !currentText.contains(" ") {
            tagInputTextField.text = String(currentText.prefix(tagMaxCount))
        } else {
            tagInputTextField.text = String(currentText.prefix(firstTagCount + 1 + tagMaxCount))
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = (textField.text ?? "")
        let updatedText = currentText+string
        
        if textField.tag == 0 {
            if updatedText.count > 18 + 1 {
                titleInputTextField.text = String(updatedText.prefix(18))
                return false
            }
            return true
        }

        if currentText.count == 1 && string.isEmpty {
            return false
        }
        
        if !currentText.contains(" ") {
            if updatedText.count > tagMaxCount + 1 {
                tagInputTextField.text = String(updatedText.prefix(tagMaxCount))
                return false
            }
        }
        
        if string == " " {
            if currentText.contains(" ") {
                return false
            } else {
                firstTagCount = currentText.count
                tagInputTextField.text = "\(currentText) #"
                return false
            }
        }
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 { return true }
        }
        
        if updatedText.count > firstTagCount + 1 + tagMaxCount + 1 {
            tagInputTextField.text = String(updatedText.prefix(firstTagCount + 1 + tagMaxCount))
            return false
        }
        
        return true
    }
    
    func moveCursorToEnd(_ textField: UITextField) {
        if let endPosition = textField.position(from: textField.endOfDocument, offset: 0) {
            textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
        }
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 1 { moveCursorToEnd(textField) }
    }
}
