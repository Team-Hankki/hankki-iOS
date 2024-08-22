//
//  AddMenuCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/10/24.
//

import UIKit

final class AddMenuCollectionViewCell: BaseCollectionViewCell {
        
    // MARK: - UI Components
    
    let addMenuButton: UIButton = UIButton()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubview(addMenuButton)
    }
    
    override func setupLayout() {
        addMenuButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(32)
        }
    }
    
    override func setupStyle() {
        addMenuButton.do {
            $0.setImage(.btnAddDetailBig, for: .normal)
            $0.setAttributedTitle(UILabel.setupAttributedText(
                for: PretendardStyle.body2,
                withText: StringLiterals.Report.addMenu,
                color: .gray400
            ), for: .normal)
            $0.configuration = .plain()
            $0.configuration?.imagePadding = 8
        }
    }
}
