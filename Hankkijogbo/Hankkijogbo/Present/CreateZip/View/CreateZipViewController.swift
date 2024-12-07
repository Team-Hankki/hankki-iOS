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
    
    private let titleCountView = UIView()
    private let titleCountLabel = UILabel()
    
    private let titleTextField = CreateZipTextField(
        type: .title,
        titleText: StringLiterals.CreateZip.TitleInput.label,
        placeholderText: StringLiterals.CreateZip.TitleInput.placeholder,
        maxLength: 18,
        regex: "^[ㄱ-힣a-zA-Z0-9{}\\[\\]/?.,;:|)*~`!^\\-_+<>@#\\$%&\\\\=\\('\"\"\\\\]*$"
    )
    
    private let tagTextField = CreateZipTextField(
        type: .tag,
        titleText: StringLiterals.CreateZip.TagInput.label,
        placeholderText: StringLiterals.CreateZip.TagInput.placeholder,
        maxLength: 9 * 2 + 1,
        regex: "^[ㄱ-힣a-zA-Z0-9]+$"
    )
    
    private lazy var submitButton = MainButton(
        titleText: StringLiterals.CreateZip.submitButton,
        isValid: false,
        buttonHandler: submitButtonDidTap
    )
    
    private let hankkiAccessoryView = HankkiAccessoryView(text: StringLiterals.CreateZip.submitButton)
    
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
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h1,
                withText: StringLiterals.CreateZip.viewTitle,
                color: .gray900
            )
        }
        
        descriptionLabel.do {
            $0.numberOfLines = 2
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body6,
                withText: StringLiterals.CreateZip.viewDescription,
                color: .gray400
            )
        }
    }
    
    override func setupHierarchy() {
        view.addSubviews(
            viewTitleLabel,
            descriptionLabel,
            titleTextField,
            tagTextField,
            submitButton
        )
    }
    
    override func setupLayout() {
        viewTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(19)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(viewTitleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().offset(22)
        }
        
        titleTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(36)
        }
        
        tagTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
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
    
    func setupInputAccessoryView() {
        let accessoryView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.getDeviceWidth(), height: 54))
        accessoryView.addSubview(hankkiAccessoryView)
        hankkiAccessoryView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        //        titleInputTextField.inputAccessoryView = accessoryView
        //        tagInputTextField.inputAccessoryView = accessoryView
    }
    
    func setupDelegate() {
        //        titleInputTextField.delegate = self
        //        tagInputTextField.delegate = self
    }
    
    func setupAddTarget() {
        //        titleInputTextField.addTarget(self, action: #selector(titleTextFieldDidChange), for: .editingChanged)
        //        titleInputTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        //        tagInputTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        hankkiAccessoryView.button.addTarget(self, action: #selector(submitButtonDidTap), for: .touchUpInside)
    }
    
    @objc func textFieldDidChange() {
        isFormValid()
    }
    
    @objc func titleTextFieldDidChange(_ textField: UITextField) {
        let currentText = textField.text ?? ""
        if currentText.count <= titleMaxCount { titleCountLabel.text = "(\(currentText.count)/\(titleMaxCount))" }
    }
    
    @objc func submitButtonDidTap() {
        //        let arr = (tagInputTextField.text ?? "").split(separator: " ").map { String($0) }
        //        let data = PostZipRequestDTO(title: titleInputTextField.text ?? " ", details: arr)
        
        //        viewModel.postZip(data, onConflict: resetTitleTextField, completion: dismissSelf)
    }
    
    func resetTitleTextField() {
        titleTextField.value = ""
        submitButton.setupIsValid(false)
        hankkiAccessoryView.updateStyle(isValid: false)
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
        //        let isValid = !(titleInputTextField.text ?? "").isEmpty && (tagInputTextField.text ?? "").count > 1
        let isValid = true
        submitButton.setupIsValid(isValid)
        hankkiAccessoryView.updateStyle(isValid: isValid)
    }
}
