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
        placeholderText: StringLiterals.ModifyMenu.namePlaceholder,
        hankkiTextFieldDelegate: self
    )
    private lazy var priceTextField: ModifyMenuTextField = ModifyMenuTextField(
        titleText: StringLiterals.ModifyMenu.price,
        
        hankkiTextFieldDelegate: self
    )
    private let over8000PriceLabel: UILabel = UILabel()
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
            over8000PriceLabel,
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
            $0.numberOfLines = 2
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
                font: PretendardStyle.body2,
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
        }
    }
    
    func deleteMenu() {
        viewModel.deleteMenuAPI { [self] in
            let completeView: MenuCompleteView = MenuCompleteView(
                firstSentence: StringLiterals.ModifyMenu.completeByYou,
                secondSentence: StringLiterals.ModifyMenu.deleteMenuComplete,
                completeImage: .imgDeleteComplete
            )
            let deleteMenuCompleteViewController = CompleteViewController(completeView: completeView)
            navigationController?.pushViewController(deleteMenuCompleteViewController, animated: true)
        }
    }
    
    func postNotification() {
        NotificationCenter.default.post(Notification(name: NSNotification.Name(StringLiterals.NotificationName.reloadHankkiDetail)))
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
                modifyOtherMenuButtonAction: { self.popToEditMenu() },
                completeButtonAction: {
                    self.postNotification()
                    self.popToRoot()
                }
            )
            let modifyMenuCompleteViewController = CompleteViewController(completeView: completeView)
            navigationController?.pushViewController(modifyMenuCompleteViewController, animated: true)
        }
    }
}

// MARK: - HankkiTextFieldDelegate

extension ModifyMenuViewController: ModifyMenuTextFieldDelegate {
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
    
    func showErrorLabel(isWarn: Bool) {
        over8000PriceLabel.isHidden = !isWarn
    }
    
    func showDeleteAlert() {
        showAlert(titleText: StringLiterals.Alert.DeleteMenu.title,
                  secondaryButtonText: StringLiterals.Alert.DeleteMenu.secondaryButton,
                  primaryButtonText: StringLiterals.Alert.DeleteMenu.primaryButton,
                  primaryButtonHandler: deleteMenu)
    }
}
