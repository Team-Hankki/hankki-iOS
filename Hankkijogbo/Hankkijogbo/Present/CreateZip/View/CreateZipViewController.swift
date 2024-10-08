//
//  CreateZipViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/11/24.
//

import UIKit

final class CreateZipViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let isBottomSheetOpen: Bool
    private let storeId: Int?
    
    private let viewModel: CreateZipViewModel = CreateZipViewModel()
    
    private let tagMaxCount: Int = 9
    private let titleMaxCount: Int = 18
    
    private var firstTagCount: Int = 0
    
    // MARK: - UI Properties
    
    private let viewTitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let titleInputTitle = UILabel()
    private let titleInputTextField = UITextField()
    private let titleInputLineView = UIView()
    
    private let titleCountView = UIView()
    private let titleCountLabel = UILabel()
    
    private let tagInputTitle = UILabel()
    private let tagInputTextField = TagTextField()
    private let tagInputLineView = UIView()
    
    private lazy var submitButton = MainButton(titleText: StringLiterals.CreateZip.submitButton, isValid: false, buttonHandler: submitButtonDidTap)
    
    // MARK: - Life Cycle
    
    init(isBottomSheetOpen: Bool, storeId: Int? = nil) {
        self.isBottomSheetOpen = isBottomSheetOpen
        self.storeId = storeId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupAddTarget()
        self.hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Set UI
    
    override func setupStyle() {
        viewTitleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: SuiteStyle.h1,
                                                            withText: StringLiterals.CreateZip.viewTitle,
                                                            color: .gray900)
        }
        
        descriptionLabel.do {
            $0.numberOfLines = 2
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body6,
                                                            withText: StringLiterals.CreateZip.viewDescription,
                                                            color: .gray400)
        }
        
        titleInputTitle.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body6,
                                                            withText: StringLiterals.CreateZip.TitleInput.label,
                                                            color: .gray500)
        }
        
        titleInputTextField.do {
            $0.tag = 0
            $0.addPadding(left: 8, right: 14)
            $0.font = UIFont.setupPretendardStyle(of: .subtitle2)
            $0.textColor = .gray800
            
            $0.changePlaceholderColor(forPlaceHolder: StringLiterals.CreateZip.TitleInput.placeholder,
                                      forColor: .gray300)
            
            $0.rightViewMode = .always
            $0.rightView = titleCountView
        }
        
        titleInputLineView.do {
            $0.backgroundColor = .gray200
        }
            
        titleCountLabel.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body8,
                                                            withText: "(0/\(titleMaxCount))",
                                                            color: .gray300)
        }
        
        tagInputTitle.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body6,
                                                            withText: StringLiterals.CreateZip.TagInput.label,
                                                            color: .gray500)
        }
        
        tagInputTextField.do {
            $0.tag = 1
            $0.addPadding(left: 8)
            $0.font = UIFont.setupPretendardStyle(of: .subtitle2)
            $0.textColor = .gray800
            
            $0.changePlaceholderColor(forPlaceHolder: StringLiterals.CreateZip.TagInput.placeholder,
                                      forColor: .gray300)
        }
        
        tagInputLineView.do {
            $0.backgroundColor = .gray200
        }

    }
    
    override func setupHierarchy() {
        view.addSubviews(
            viewTitleLabel,
            descriptionLabel,
            titleInputTitle,
            titleInputTextField,
            titleInputLineView,
            tagInputTitle,
            tagInputTextField,
            tagInputLineView,
            submitButton
        )
        titleCountView.addSubview(titleCountLabel)
    }
    
    override func setupLayout() {
        viewTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(34)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(viewTitleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().offset(22)
        }
        
        titleInputTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(36)
        }
        
        titleInputTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.top.equalTo(titleInputTitle.snp.bottom)
            $0.height.equalTo(40)
        }
        
        titleInputLineView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.height.equalTo(1)
            $0.top.equalTo(titleInputTextField.snp.bottom)
        }
        
        tagInputTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalTo(titleInputLineView.snp.bottom).offset(20)
        }
        
        tagInputTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.top.equalTo(tagInputTitle.snp.bottom)
            $0.height.equalTo(40)
        }
        
        tagInputLineView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.height.equalTo(1)
            $0.top.equalTo(tagInputTextField.snp.bottom)
        }
        
        titleCountView.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(50)
        }
        
        titleCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
        }
        submitButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(54)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

private extension CreateZipViewController {
    func setupNavigationBar() {
        let type: HankkiNavigationType = HankkiNavigationType(hasBackButton: true,
                                                              hasRightButton: false,
                                                              mainTitle: .string(""),
                                                              rightButton: .string(""),
                                                              rightButtonAction: {})
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
    
    func setupDelegate() {
        titleInputTextField.delegate = self
        tagInputTextField.delegate = self
    }
    
    func setupAddTarget() {
        titleInputTextField.addTarget(self, action: #selector(titleTextFieldDidChange), for: .editingChanged)
        titleInputTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tagInputTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        isFormValid()
    }
    
    @objc func titleTextFieldDidChange(_ textField: UITextField) {
        let currentText = textField.text ?? ""
        if currentText.count <= titleMaxCount { titleCountLabel.text = "(\(currentText.count)/\(titleMaxCount))" }
    }
    
    func submitButtonDidTap() {
        let arr = (tagInputTextField.text ?? "").split(separator: " ").map { String($0) }
        let data = PostZipRequestDTO(title: titleInputTextField.text ?? " ", details: arr)
        
        viewModel.postZip(data, onConflict: resetTitleTextField, completion: dismissSelf)
    }
    
    func resetTitleTextField() {
        self.titleInputTextField.text = ""
        submitButton.setupIsValid(false)
    }
    
    func dismissSelf() {
        DispatchQueue.main.async {
            // 족보 만들기를 완료해서, 서버에서 생성이되면 이전 페이지로 이동한다
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController as? UINavigationController {
                rootViewController.popViewController(animated: true)
                if let id = self.storeId {
                    rootViewController.presentMyZipListBottomSheet(id: id)
                }
            }
        }
    }
    
    func isFormValid() {
        if !(titleInputTextField.text ?? "").isEmpty && (tagInputTextField.text ?? "").count > 1 {
            submitButton.setupIsValid(true)
        } else {
            submitButton.setupIsValid(false)
        }
    }
}

// MARK: - delegate

extension CreateZipViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            titleInputLineView.backgroundColor = .gray500
        } else if textField.tag == 1 {
            tagInputLineView.backgroundColor = .gray500
        }
        
        switch textField.tag {
        case 0:
            titleCountLabel.textColor = .gray500
        case 1:
            let currentText = textField.text ?? ""
            if currentText.isEmpty {
                textField.text = "#"
            }
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            titleInputLineView.backgroundColor = .gray200
        } else if textField.tag == 1 {
            tagInputLineView.backgroundColor = .gray200
        }
        
        let currentText = textField.text ?? ""
        
        if textField.tag == 0 {
            titleCountLabel.textColor = .gray300
            titleInputTextField.text = String(currentText.prefix(titleMaxCount))
            return
        }
        
        if currentText.count <= 1 {
            textField.text = ""
            return
        }
        
        if !currentText.contains(" ") {
            tagInputTextField.text = String(currentText.prefix(tagMaxCount))
        } else {
            if currentText.hasSuffix("#") {
                let arr = (tagInputTextField.text ?? "").split(separator: " ").map { String($0) }
                tagInputTextField.text = arr[0]
                return
            }
            
            tagInputTextField.text = String(currentText.prefix(firstTagCount + 1 + tagMaxCount))
        }
    }
    
    func isValidString(_ s: String, regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: s)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = (textField.text ?? "")
        let updatedText = currentText+string
        
        let titleRegex = "^[ㄱ-힣a-zA-Z0-9{}\\[\\]/?.,;:|)*~`!^\\-_+<>@#\\$%&\\\\=\\('\"\"\\\\]*$"
        let tagRegex = "^[ㄱ-힣a-zA-Z0-9]+$"
        
        // 정규식에 맞는 텍스트만 입력되도록 합니다. (+ 스페이스 바, 백스페이스)
        if !isValidString(string, regex: textField.tag == 0 ? titleRegex : tagRegex) && string != " " && !string.isEmpty {
            return false
        }
        
        // textField.tag == 0 : 족보 제목
        // TextField의 글자 수를 제한 합니다.
        if textField.tag == 0 {
            if updatedText.count > titleMaxCount + 1 {
                titleInputTextField.text = String(updatedText.prefix(titleMaxCount))
                return false
            }
            return true
        }
        
        // textField.tag == 1 : 족보 태그
        
        // 현재 입력된 TextField의 마지막글자를 반환합니다.
        var lastChar = ""
        if let text = currentText.last {
            lastChar = String(text)
        }
        
        // 현재 입력된 TextField의 마지막 글자가 #인 경우
        if lastChar == "#" {
            // 텍스트 필드의 상태 : #태그1 #
            // 첫번째 태그가 입력이 완료 되었고, 두번째 태그를 작성해야하는데 백스페이스를 입력한 경우
            // 두번째 태그의 입력이 취소 되고, 첫번째 태그를 수정할 수 있게 해야한다.
            // -> 글자를 지우면 미리 입력된 #과, 태그를 분리하는 띄워쓰기를 동시에 지운다.
            if string.isEmpty && currentText.count > 1 {
                tagInputTextField.text = String(currentText.prefix(currentText.count - 2))
                return false
            }
            // 텍스트 필드의 상태 : #
            // 첫번째 태그가 입력되지 않은 상태에서, 띄어쓰기로 두번재 태그를 작성하려는 경우
            // 두번째 태그 작성이 안되게 막아야한다. (첫번째 태그값이 공백이 되면 안됨)
            // -> 첫번째 태그가 입력되지 않으면 스페이스 키 입력을 막아 2번째 텍스트가 작성되지 않도록한다.
            else if currentText.count == 1 && string == " " {
                return false
            }
        }
        
        // 텍스트 필드의 상태 : #
        // 현재 입력 : 백스페이스 (지우기)
        // 첫번째 태그를 작성하지 않고, 백페이스를 입력해 작성되어있던 #도 지우려는 경우
        // -> 지우기가 되지 않아야한다.
        if currentText.count == 1 && string.isEmpty {
            return false
        }
        
        // 첫번째 태그가 최대 글자수를 넘지 않게 막는다.
        if !currentText.contains(" ") && updatedText.count > tagMaxCount + 1 {
            tagInputTextField.text = String(updatedText.prefix(tagMaxCount))
            return false
        }
        
        // 현재 입력 : 스페이스
        if string == " " {
            // 텍스트 필드의 상태 : #태그1 #태그2작성중
            // 첫번째 태그를 입력하고, 두번째 태그를 입력하고 있는 중, 한번 더 스페이스를 눌러 3번째 태그를 추가하려는 경우
            // -> 스페이스가 입력되지 않게 막아야한다.
            if currentText.contains(" ") {
                return false
            }
            // 텍스트 필드의 상태 : #태그1
            // 첫번째 태그를 입력을 마무리하고, 두번째 태그를 작성하려고하는 경우
            // -> 첫번째 태그를 완성하고, 두번째 태그 작성을 위해 #을 자동으로 입력한다.
            else {
                firstTagCount = currentText.count
                tagInputTextField.text = "\(currentText) #"
                return false
            }
        }
        
        // 두번째 태그가 최대 글자수를 넘지 않게 막는다.
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
