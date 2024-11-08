//
//  EnterMenuAccessoryView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 11/8/24.
//

import UIKit

/// - 메뉴 정보 입력 시 뜨는 악세사리 뷰
class EnterMenuAccessoryView: BaseView {
    
    // MARK: - Properties
    
    var titleText: String
    
    // MARK: - UI Components
    
    let applyButton: UIButton = UIButton()
    let resetButton: UIButton = UIButton()
        
    // MARK: - Init
    
    init(titleText: String) {
        self.titleText = titleText
        super.init(frame: .zero)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    override func setupStyle() {
        applyButton.do {
            $0.backgroundColor = .red400
            $0.setAttributedTitle(
                UILabel.setupAttributedText(
                    for: PretendardStyle.subtitle3,
                    withText: StringLiterals.ModifyMenu.applyButton,
                    color: .hankkiWhite
                ), for: .normal)
        }
        
        resetButton.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 8
            $0.setAttributedTitle(
                UILabel.setupAttributedText(
                    for: PretendardStyle.body7,
                    withText: "기존 메뉴\(titleText.suffix(2)) 입력",
                    color: .gray600
                ),
                for: .normal
            )
        }
    }
    
    override func setupHierarchy() {
        addSubviews(applyButton, resetButton)
    }

    override func setupLayout() {
        applyButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        resetButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(applyButton.snp.top).offset(-20)
            $0.width.equalTo(121)
            $0.height.equalTo(36)
        }
    }
}
