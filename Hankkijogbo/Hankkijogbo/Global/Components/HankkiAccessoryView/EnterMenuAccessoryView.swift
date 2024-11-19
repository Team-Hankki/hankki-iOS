//
//  EnterMenuAccessoryView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 11/8/24.
//

import UIKit

/// - 메뉴 정보 입력 시 뜨는 악세사리 뷰
final class EnterMenuAccessoryView: BaseView {
    
    // MARK: - Properties
    
    var titleText: String
    
    // MARK: - UI Components
    
    let hankkiAccessoryView: HankkiAccessoryView = HankkiAccessoryView(text: StringLiterals.ModifyMenu.modifyMenuCompleteButton)
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
        resetButton.do {
            $0.isHidden = true
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 8
            $0.setAttributedTitle(
                UILabel.setupAttributedText(
                    for: PretendardStyle.body7,
                    withText: "기존 \(titleText) 입력",
                    color: .gray600
                ),
                for: .normal
            )
        }
    }
    
    override func setupHierarchy() {
        addSubviews(hankkiAccessoryView, resetButton)
    }

    override func setupLayout() {
        hankkiAccessoryView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        resetButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(hankkiAccessoryView.snp.top).offset(-20)
            $0.width.equalTo(121)
            $0.height.equalTo(36)
        }
    }
}
