//
//  MenuCompleteView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 11/8/24.
//

import UIKit

final class MenuCompleteView: BaseView {
    
    // MARK: - Properties
    
    typealias ButtonAction = (() -> Void)
    
    private let firstSentence: String
    private let secondSentence: String
    private let completeImage: UIImage
    private let modifyOtherMenuButtonAction: ButtonAction?
    private let completeButtonAction: ButtonAction?
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = UILabel()
    private let completeImageView: UIImageView = UIImageView()
    private let modifyOtherMenuButton: UIButton = UIButton()
    private lazy var completeButtonView: BottomButtonView = BottomButtonView(
        primaryButtonText: StringLiterals.Common.complete,
        primaryButtonHandler: completeButtonAction,
        gradientColor: .clear
    )
        
    // MARK: - Life Cycle
    
    init(
        firstSentence: String,
        secondSentence: String,
        completeImage: UIImage,
        modifyOtherMenuButtonAction: ButtonAction? = nil,
        completeButtonAction: ButtonAction? = nil
    ) {
        self.firstSentence = firstSentence
        self.secondSentence = secondSentence
        self.completeImage = completeImage
        self.modifyOtherMenuButtonAction = modifyOtherMenuButtonAction
        self.completeButtonAction = completeButtonAction
        super.init(frame: .zero)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        addSubviews(
            titleLabel,
            completeImageView,
            completeButtonView,
            modifyOtherMenuButton
        )
    }
    
    override func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(112)
            $0.leading.equalToSuperview().inset(24)
        }
        
        completeImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(completeButtonView.snp.top)
        }
        
        completeButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(154)
        }
        
        if modifyOtherMenuButtonAction != nil {
            modifyOtherMenuButton.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(22)
                $0.bottom.equalTo(completeButtonView.snp.top).offset(42)
                $0.height.equalTo(54)
            }
        }
    }
    
    override func setupStyle() {
        titleLabel.do {
            $0.numberOfLines = 2
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h2,
                withText: UserDefaults.standard.getNickname() + firstSentence + secondSentence,
                color: .gray850
            )
        }
        
        completeImageView.do {
            $0.image = completeImage
        }
        
        if modifyOtherMenuButtonAction != nil {
            modifyOtherMenuButton.do {
                $0.setAttributedTitle(UILabel.setupAttributedText(
                    for: PretendardStyle.subtitle3,
                    withText: StringLiterals.ModifyMenu.modifyOtherMenuButton,
                    color: .red500
                ), for: .normal)
                $0.backgroundColor = .hankkiWhite
                $0.makeRoundBorder(cornerRadius: 16, borderWidth: 1, borderColor: .red500)
                $0.addTarget(self, action: #selector(modifyOtherMenuButtonDidTap), for: .touchUpInside)
            }
        }
        
        completeButtonView.do {
            $0.setupEnabledDoneButton()
        }
    }
    
    @objc private func modifyOtherMenuButtonDidTap() {
        modifyOtherMenuButtonAction?()
    }
}