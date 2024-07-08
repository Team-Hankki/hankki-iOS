//
//  UnivSelectViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import UIKit

final class UnivSelectViewController: BaseViewController {
    // MARK: - Properties
    
    var currentUniv: String = ""

    // MARK: - UI Properties
    
    private let headerStackView: UIStackView = UIStackView()
    private let headerTitleLabel: UILabel = UILabel()
    private let headerContentLabel: UILabel = UILabel()
    
    private let bottomButtonView: UIView = UIView()
    private let doneButton: UIButton = UIButton()
    private let laterButton: UIButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func setupStyle() {
        headerStackView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 38, left: 22, bottom: 34, right: 22)
        }
        
        headerTitleLabel.do {
            $0.numberOfLines = 1
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h1,
                withText: "나의 대학교를 선택해보세요",
                color: .gray900
            )
        }
        
        headerContentLabel.do {
            $0.numberOfLines = 2
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body4,
                withText: "아직 등록되지 않은 대학(지역)이 있어요.\n조금만 기다려주세요 :)",
                color: .gray400
            )
        }
        
        bottomButtonView.do {
            $0.backgroundColor = .hankkiWhite
        }
        
        doneButton.do {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: "선택하기",
                color: .hankkiWhite
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
                $0.backgroundColor = .hankkiRed
                $0.layer.cornerRadius = 16
            }
        }
        
        laterButton.do {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.button,
                withText: "찾는 대학교가 없어요. 우선 둘러볼게요!",
                color: .gray400
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
        }
    }
    
    override func setupHierarchy() {
        view.addSubviews(headerStackView, bottomButtonView)
        headerStackView.addArrangedSubviews(headerTitleLabel, headerContentLabel)
        bottomButtonView.addSubviews(doneButton, laterButton)
    }
    
    override func setupLayout() {
        headerStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        bottomButtonView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.height.equalTo(54)
        }
        
        laterButton.snp.makeConstraints {
            $0.top.equalTo(doneButton.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}
