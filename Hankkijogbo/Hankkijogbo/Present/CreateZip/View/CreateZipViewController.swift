//
//  CreateZipViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/11/24.
//

import UIKit

struct CreateZipLiterals {
    static let titleMaxCount: Int = 18
    static let titleRegex: String = "^[ㄱ-힣a-zA-Z0-9{}\\[\\]/?.,;:|)*~`!^\\-_+<>@#\\$%&\\\\=\\('\"\"\\\\]*$"
    
    static let tagMaxCount: Int = 9
    static let tagRegex: String = "^[ㄱ-힣a-zA-Z0-9]+$"
}

final class CreateZipViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let type: CreateZipViewControllerType
    private let isBottomSheetOpen: Bool
    private let storeId: Int?
    private let zipId: Int?
    
    private let viewModel: CreateZipViewModel = CreateZipViewModel()
    
    private var firstTagCount: Int = 0
    
    // MARK: - UI Properties
    
    private let viewTitleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    
    private lazy var titleTextField: CreateZipTextField = CreateZipTextField(.title) { [weak self] in
        self?.isFormValid()
    }
    private lazy var tagTextField: CreateZipTextField = CreateZipTextField(.tag) { [weak self] in
        self?.isFormValid()
    }
    
    private lazy var submitButton: MainButton = MainButton(
        titleText: type.submitButtonText,
        isValid: false,
        buttonHandler: submitButtonDidTap
    )
    
    private lazy var hankkiAccessoryView: HankkiAccessoryView = HankkiAccessoryView(text: type.submitButtonText)
    
    // MARK: - Life Cycle
    
    init(isBottomSheetOpen: Bool, storeId: Int? = nil, zipId: Int? = nil, type: CreateZipViewControllerType = .myZip) {
        self.isBottomSheetOpen = isBottomSheetOpen
        self.storeId = storeId
        self.zipId = zipId
        self.type = type
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupAddTarget()
        setupTextFieldAccessoryView()
        
        self.hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Set UI
    
    override func setupStyle() {
        viewTitleLabel.do {
            $0.numberOfLines = 0
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h1,
                withText: type.viewTitle,
                color: .gray900
            )
        }
        
        descriptionLabel.do {
            $0.numberOfLines = 0
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body6,
                withText: type.viewDescription,
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

// MARK: - setup
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
    
    func setupTextFieldAccessoryView() {
        let accessoryView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.getDeviceWidth(), height: 54))
        accessoryView.addSubview(hankkiAccessoryView)
        hankkiAccessoryView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleTextField.setupAccessoryView(accessoryView)
        tagTextField.setupAccessoryView(accessoryView)
    }
    
    func setupAddTarget() {
        submitButton.addTarget(self, action: #selector(submitButtonDidTap), for: .touchUpInside)
        hankkiAccessoryView.button.addTarget(self, action: #selector(submitButtonDidTap), for: .touchUpInside)
    }
}

private extension CreateZipViewController {
    
    @objc func submitButtonDidTap() {
        let title: String = titleTextField.value
        let tagList: [String] = tagTextField.value.split(separator: " ").map { String($0) }
        
        let data = PostZipRequestDTO(title: title, details: tagList)
        
        switch type {
        case .sharedZip:
            // 공유된 족보를 내 족보에 추가
            viewModel.postSharedZip(data, zipId: zipId!, onConflict: resetTitleTextField, completion: presentMyZipListViewController)
            
        case .myZip:
            // 내 족보를 새로 만들기
            viewModel.postZip(data, onConflict: resetTitleTextField, completion: dismissSelf)
        }
        
    }
    
    // textField 값의 유효성 검사
    func isFormValid() {
        let isValid = !(titleTextField.value).isEmpty
                    && (tagTextField.value).count > 1
        updateSubmitButton(isValid)
    }
    
    func resetTitleTextField() {
        titleTextField.resetTextField()
        updateSubmitButton(false)
    }
    
    func updateSubmitButton(_ isValid: Bool) {
        submitButton.setupIsValid(isValid)
        hankkiAccessoryView.updateStyle(isValid: isValid)
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
    
    func presentMyZipListViewController() {
        DispatchQueue.main.async {
            // 족보 만들기를 완료해서, 서버에서 생성이되면 나의 족보 리스트 페이지로 이동한다.
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    let tabBarController = TabBarController()
                    tabBarController.selectedIndex = 2
                    let navigationController = HankkiNavigationController(rootViewController: tabBarController)
                    
                    window.rootViewController = navigationController
                    navigationController.pushViewController(ZipListViewController(), animated: false)
                }
            }
        }
    }
}
