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
    private lazy var nameTextField: ModifyMenuTextField = ModifyMenuTextField(
        titleText: StringLiterals.ModifyMenu.name,
        originalText: viewModel.selectedMenu.name,
        placeholderText: StringLiterals.ModifyMenu.namePlaceholder,
        modifyMenuTextFieldDelegate: self
    )
    private lazy var priceTextField: ModifyMenuTextField = ModifyMenuTextField(
        titleText: StringLiterals.ModifyMenu.price,
        originalText: String(viewModel.selectedMenu.price),
        modifyMenuTextFieldDelegate: self
    )
    private let over8000PriceLabel: UILabel = UILabel()
    private lazy var bottomButtonView: BottomButtonView = BottomButtonView(
        primaryButtonText: StringLiterals.ModifyMenu.modifyMenuCompleteButton,
        primaryButtonHandler: showModifyCompleteAlert
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
            over8000PriceLabel,
            bottomButtonView,
            carefulGuideLabel
        )
    }
    
    override func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            $0.leading.trailing.equalToSuperview().inset(22)
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
        
        over8000PriceLabel.snp.makeConstraints {
            $0.top.equalTo(priceTextField.snp.bottom).offset(6)
            $0.trailing.equalTo(priceTextField)
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
            $0.numberOfLines = 0
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h2,
                withText: viewModel.selectedMenu.name + StringLiterals.ModifyMenu.modifyMenuTitle,
                color: .gray900
            )
            $0.setupTextColorRange(start: 0, end: viewModel.selectedMenu.name.count, color: .red500)
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
                font: PretendardStyle.body3,
                textColor: .gray800
            )
            $0.keyboardType = .numberPad
        }
        
        over8000PriceLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.caption1,
                withText: StringLiterals.ModifyMenu.overPriceErrorText,
                color: .warnRed
            )
            $0.isHidden = true
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
            self.nameTextField.enterMenuAccessoryView.hankkiAccessoryView.updateStyle(isValid: isActive)
            self.priceTextField.enterMenuAccessoryView.hankkiAccessoryView.updateStyle(isValid: isActive)
        }
    }
    
    func deleteMenu() {
        viewModel.deleteMenuAPI { [weak self] in
            guard let self = self else { return }
            
            let isLastMenu = self.viewModel.isLastMenu
            let completeView = MenuCompleteView(
                firstSentence: StringLiterals.ModifyMenu.completeByYou,
                secondSentence: StringLiterals.ModifyMenu.deleteMenuComplete,
                completeImage: .imgDeleteComplete,
                doThisAgainButtonText: isLastMenu ? nil : StringLiterals.ModifyMenu.editOtherMenuButton,
                doThisAgainButtonAction: isLastMenu ? nil : { self.popToEditMenu() },
                completeButtonAction: { self.popToRoot() }
            )
            
            let deleteMenuCompleteViewController = CompleteViewController(completeView: completeView)
            self.navigationController?.pushViewController(deleteMenuCompleteViewController, animated: true)
        }
    }
    
    func popToEditMenu() {
        if let editMenuViewController = navigationController?.viewControllers.first(where: {
            $0 is EditMenuViewController
        }) {
            navigationController?.popToViewController(editMenuViewController, animated: true)
        }
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - @objc Func
    
    @objc func completeButtonDidTap() {
        viewModel.modifyMenuAPI { [self] in
            let completeView: MenuCompleteView = MenuCompleteView(
                firstSentence: StringLiterals.ModifyMenu.completeByYou,
                secondSentence: StringLiterals.ModifyMenu.modifyMenuComplete,
                completeImage: .imgModifyComplete,
                doThisAgainButtonText: StringLiterals.ModifyMenu.editOtherMenuButton,
                doThisAgainButtonAction: { self.popToEditMenu() },
                completeButtonAction: { self.popToRoot() }
            )
            let modifyMenuCompleteViewController = CompleteViewController(completeView: completeView)
            navigationController?.pushViewController(modifyMenuCompleteViewController, animated: true)
        }
        
        SetupAmplitude.shared.logEvent(AmplitudeLiterals.Detail.tabMenuEditCompleted)
    }
}

// MARK: - HankkiTextFieldDelegate

extension ModifyMenuViewController: ModifyMenuTextFieldDelegate {
    
    func updateModifiedMenuData(textField: UITextField) {
        guard let text = textField.text else { return }
        switch textField {
        case nameTextField:
            viewModel.modifiedMenuData.name = text
        case priceTextField:
            viewModel.modifiedMenuData.price = Int(text) ?? 0
        default:
            break
        }
    }
    
    func updateErrorLabelVisibility(isHidden: Bool) {
        over8000PriceLabel.isHidden = isHidden
    }
    
    func showDeleteAlert() {
        let titleText = viewModel.isLastMenu
        ? StringLiterals.Alert.DeleteLastMenu.title
        : StringLiterals.Alert.DeleteMenu.title
        let secondaryButtonText = viewModel.isLastMenu
        ? StringLiterals.Alert.DeleteLastMenu.secondaryButton
        : StringLiterals.Alert.DeleteMenu.secondaryButton
        let primaryButtonText = viewModel.isLastMenu
        ? StringLiterals.Alert.DeleteLastMenu.primaryButton
        : StringLiterals.Alert.DeleteMenu.primaryButton
        
        showAlert(
            titleText: titleText,
            secondaryButtonText: secondaryButtonText,
            primaryButtonText: primaryButtonText,
            primaryButtonHandler: deleteMenu
        )
    }
    
    func showModifyCompleteAlert() {
        showAlert(
            titleText: StringLiterals.Alert.ModifyCompleteMenu.title,
            secondaryButtonText: StringLiterals.Alert.ModifyCompleteMenu.secondaryButton,
            primaryButtonText: StringLiterals.Alert.ModifyCompleteMenu.primaryButton,
            primaryButtonHandler: completeButtonDidTap
        )
    }
}
