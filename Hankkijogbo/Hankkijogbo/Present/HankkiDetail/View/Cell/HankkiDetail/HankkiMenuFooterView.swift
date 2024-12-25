//
//  HankkiMenuFooterView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiMenuFooterView: BaseCollectionReusableView {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    let editButton: UIButton = UIButton()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubview(editButton)
    }
    
    override func setupLayout() {
        editButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.bottom.equalToSuperview().inset(18)
        }
    }
    
    override func setupStyle() {
        editButton.do {
            $0.configuration = .plain()
            $0.configuration?.image = .icEditDetail
            $0.configuration?.imagePadding = 4
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.body5,
                withText: StringLiterals.HankkiDetail.editMenu,
                color: .gray600
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            $0.configuration?.titleAlignment = .center
            $0.backgroundColor = .gray100
            $0.makeRoundCorners(radius: 8)
        }
    }
}
