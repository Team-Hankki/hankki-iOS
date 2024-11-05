//
//  AddMenuCompleteViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/8/24.
//

// MARK: - 메뉴 추가 완료 결과 화면

import UIKit

final class AddMenuCompleteViewController: BaseViewController {
    
    // MARK: - Properties
    
    let storeId: Int
    let totalMenuCount: Int
    
    // MARK: - UI Components
    
    let titleLabel: UILabel = UILabel()
    let completeImageView: UIImageView = UIImageView()
    private lazy var bottomButtonView: BottomButtonView = BottomButtonView(
        primaryButtonText: StringLiterals.Common.complete,
        primaryButtonHandler: bottomButtonPrimaryHandler
    )
    
    // MARK: - Life Cycle
    
    init(storeId: Int, totalMenuCount: Int) {
        self.storeId = storeId
        self.totalMenuCount = totalMenuCount
        super.init()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        view.addSubviews(
            titleLabel,
            completeImageView,
            bottomButtonView
        )
    }
    
    override func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            $0.leading.equalToSuperview().inset(24)
        }
        
        bottomButtonView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(154)
        }
        
        completeImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomButtonView.snp.top)
        }
    }
    
    override func setupStyle() {
        titleLabel.do {
            $0.numberOfLines = 2
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h2,
                withText: UserDefaults.standard.getNickname() + StringLiterals.AddMenu.addMenuCompleteByYouFirst + String(totalMenuCount) + StringLiterals.AddMenu.addMenuCompleteByYouSecond,
                color: .gray850
            )
        }
        
        bottomButtonView.do {
            $0.setupEnabledDoneButton()
        }
        
        completeImageView.do {
            $0.image = .imgAddComplete
        }
    }
    
    // MARK: - @objc Func
    
    @objc func bottomButtonPrimaryHandler() {
        navigationController?.popToRootViewController(animated: true)
    }
}
