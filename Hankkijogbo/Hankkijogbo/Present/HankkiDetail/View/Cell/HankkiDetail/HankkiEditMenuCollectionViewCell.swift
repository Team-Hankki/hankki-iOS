//
//  HankkiEditMenuCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/16/24.
//

import UIKit

final class HankkiEditMenuCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Components
    
    var editMenuButton: UIButton = UIButton()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubview(editMenuButton)
    }
    
    override func setupLayout() {
        editMenuButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(11)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        editMenuButton.do {   
            $0.setAttributedTitle(
                UILabel.setupAttributedText(
                    for: PretendardStyle.body5,
                    withText: StringLiterals.HankkiDetail.editMenu,
                    color: .gray400
                ),
                for: .normal
            )
            $0.setUnderline()
        }
    }
}
