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
    }
    
    override func setupHierarchy() {
        view.addSubviews(headerStackView)
        headerStackView.addArrangedSubviews(headerTitleLabel, headerContentLabel)
    }
    
    override func setupLayout() {
        headerStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
