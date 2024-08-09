//
//  MyZipListHeaderView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/8/24.
//

import UIKit

final class MyZipListHeaderView: BaseCollectionReusableView {
        
    // MARK: - UI Properties
    
    private let headerLabel: UILabel = UILabel()
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        self.addSubview(headerLabel)
    }
    
    override func setupLayout() {
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17)
            $0.leading.equalToSuperview().inset(22)
        }
    }
    
    override func setupStyle() {
        headerLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.caption1,
                withText: StringLiterals.MyZip.zipList,
                color: .gray500
            )
        }
    }
}
