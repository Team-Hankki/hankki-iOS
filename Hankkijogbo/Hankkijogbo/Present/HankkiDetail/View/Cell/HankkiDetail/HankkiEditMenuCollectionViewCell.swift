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
            $0.width.equalTo(120)
            $0.height.equalTo(30)
        }
    }
    
    override func setupStyle() {
        editMenuButton.do { 
            // TODO: - 버튼일 때 문제점 또 발견... setUnderline도 attributedTitle 쓰는 거라 UILabel.setupAttributedText랑 같이 쓰는 게 불가능함 쓰면 underline이 적용이 안 돼
            $0.setTitle(StringLiterals.HankkiDetail.editMenu, for: .normal)
            $0.titleLabel?.font = .setupPretendardStyle(of: .body7)
            $0.setTitleColor(.gray400, for: .normal)
            $0.setUnderline()
            $0.contentEdgeInsets = .init(top: 10, left: 10, bottom: 30, right: 10)
        }
    }
}
