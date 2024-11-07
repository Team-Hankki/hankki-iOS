//
//  ModifyMenuViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/10/24.
//

// MARK: - 메뉴 수정 화면

import UIKit

final class ModifyMenuViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: ModifyMenuViewModel
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = UILabel()
    private lazy var nameTextField: HankkiTextField = HankkiTextField(
        titleText: StringLiterals.ModifyMenu.name,
        placeholderText: StringLiterals.ModifyMenu.namePlaceholder,
        hankkiTextFieldDelegate: self
    )
    private lazy var priceTextField: HankkiTextField = HankkiTextField(
        titleText: StringLiterals.ModifyMenu.price,
        hankkiTextFieldDelegate: self
    )
    private lazy var bottomButtonView: BottomButtonView = BottomButtonView(
        primaryButtonText: StringLiterals.ModifyMenu.modifyMenuCompleteButton,
        primaryButtonHandler: completeButtonDidTap
    )
    private let carefulGuideLabel: UILabel = UILabel()
    
    // MARK: - Life Cycle
    
    init(viewModel: ModifyMenuViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        view.addSubviews(
            titleLabel,
            nameTextField,
            priceTextField,
            bottomButtonView,
            carefulGuideLabel
        )
    }
    
    override func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            $0.leading.equalToSuperview().inset(22)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
        
        priceTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
        
        bottomButtonView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(154)
        }
        
        carefulGuideLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-87)
        }
    }
    
    override func setupStyle() {
        titleLabel.do {
            $0.numberOfLines = 2
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h2,
                withText: viewModel.selectedMenu.name + StringLiterals.ModifyMenu.modifyMenuTitle,
                color: .gray900
            )
        }
        
        nameTextField.do {
            $0.addPadding(left: 73, right: 44)
        }
        
        priceTextField.do {
            $0.addPadding(left: 73)
            $0.addPaddingAndText(
                isLeft: false,
                padding: 44,
                text: StringLiterals.Common.won,
                font: PretendardStyle.body2,
                textColor: .gray800
            )
            $0.keyboardType = .numberPad
        }
        
        carefulGuideLabel.do {
            $0.text = StringLiterals.ModifyMenu.modifyCarefullyPlease
            $0.font = .setupSuiteStyle(of: .body3)
            $0.textColor = .gray400
        }
    }
}

// MARK: - Private Func

private extension ModifyMenuViewController {
    
    func bindViewModel() {
        viewModel.updateButton = { isActive in
            if isActive {
                self.bottomButtonView.setupEnabledDoneButton()
            } else {
                self.bottomButtonView.setupDisabledDoneButton()
            }
        }
    }
    
    // MARK: - @objc Func
    
    @objc func completeButtonDidTap() {
        print("수정 완료 클릭")
    }
}

// MARK: - HankkiTextFieldDelegate

extension ModifyMenuViewController: HankkiTextFieldDelegate {
    func getOriginalText(textField: UITextField) -> String {
        switch textField {
        case nameTextField:
            return viewModel.selectedMenu.name
        case priceTextField:
            return String(describing: viewModel.selectedMenu.price)
        default:
            return ""
        }
    }
    
    func handleTextFieldUpdate(textField: UITextField) {
        switch textField {
        case nameTextField:
            viewModel.modifiedMenuData.name = textField.text
        case priceTextField:
            viewModel.modifiedMenuData.price = Int(textField.text ?? "")
        default:
            break
        }
    }
}
