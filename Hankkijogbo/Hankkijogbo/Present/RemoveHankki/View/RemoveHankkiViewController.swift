//
//  RemoveHankkiViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 12/25/24.
//

import UIKit

// MARK: - 식당을 삭제하는 제보 화면

final class RemoveHankkiViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: HankkiDetailViewModel
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = UILabel()
    private let removeOptionCollectionView: RemoveOptionCollectionView = RemoveOptionCollectionView()
    private let carefulGuideLabel: UILabel = UILabel()
    private lazy var reportBottomButtonView: BottomButtonView = BottomButtonView(
        primaryButtonText: StringLiterals.RemoveHankki.reportButton,
        primaryButtonHandler: removeHankkiButtonDidTap
    )
    
    // MARK: - Life Cycle
    
    init(viewModel: HankkiDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupDelegate()
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        view.addSubviews(
            titleLabel,
            removeOptionCollectionView,
            reportBottomButtonView,
            carefulGuideLabel
        )
    }
    
    override func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            $0.leading.equalToSuperview().inset(22)
        }
        
        removeOptionCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
        }
        
        reportBottomButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(154)
            if UIScreen.hasNotch {
                $0.bottom.equalToSuperview()
            } else {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(30) // SE 대응
            }
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
                withText: StringLiterals.RemoveHankki.titleWhyRemove,
                color: .gray900
            )
        }
        
        carefulGuideLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.body3,
                withText: StringLiterals.ModifyMenu.modifyCarefullyPlease,
                color: .gray400
            )
        }
    }
}

// MARK: - Private Func

private extension RemoveHankkiViewController {
    
    func setupRegister() {
        removeOptionCollectionView.collectionView.register(RemoveOptionCollectionViewCell.self, forCellWithReuseIdentifier: RemoveOptionCollectionViewCell.className)
    }

    func setupDelegate() {
        removeOptionCollectionView.collectionView.dataSource = self
        removeOptionCollectionView.collectionView.delegate = self
    }
    
    /// 정말 제보하시겠어요? Alert 띄우기
    func showCheckAlertForRemove() {
        self.showAlert(
            titleText: StringLiterals.Alert.reallyReport,
            subText: StringLiterals.Alert.disappearInfoByReport,
            secondaryButtonText: StringLiterals.Alert.back,
            primaryButtonText: StringLiterals.Common.report,
            primaryButtonHandler: removeHankkiByReport
        )
    }
    
    /// 제보를 통한 식당 삭제
    func removeHankkiByReport() {
        viewModel.deleteHankkiAPI { [self] in
            showThanksAlert()
        }
    }
    
    /// 제보 감사 Alert 띄우기
    func showThanksAlert() {
        let nickname: String = UserDefaults.standard.getNickname()

        self.showAlert(
            image: .imgModalReport,
            titleText: nickname + StringLiterals.Alert.thanksForReport,
            primaryButtonText: StringLiterals.Alert.check,
            primaryButtonHandler: popToHomeHankkiList,
            hightlightedText: nickname,
            hightlightedColor: .red500
        )
    }
    
    // 전체 식당 리스트가 떠있는 홈으로 이동
    func popToHomeHankkiList() {
        if let viewControllers = self.navigationController?.viewControllers {
            if viewControllers.count > 2 {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
        }
    }
    
    // MARK: - @objc Func
    
    @objc func removeHankkiButtonDidTap() {
        showCheckAlertForRemove()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension RemoveHankkiViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.removeOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RemoveOptionCollectionViewCell.className, for: indexPath) as? RemoveOptionCollectionViewCell else { return UICollectionViewCell() }
        
        cell.bindData(text: viewModel.removeOptions[indexPath.item])
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UpdateReportButtonStyle Delegate

extension RemoveHankkiViewController: UpdateReportButtonStyleDelegate {
    func updateReportButtonStyle(isEnabled: Bool) {
        if isEnabled {
            reportBottomButtonView.setupEnabledDoneButton()
        } else {
            reportBottomButtonView.setupDisabledDoneButton()
        }
    }
}
