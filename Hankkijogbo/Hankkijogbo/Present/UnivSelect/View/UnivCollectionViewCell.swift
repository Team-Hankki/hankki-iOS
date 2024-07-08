//
//  UnivSelectUnivCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import UIKit

final class UnivCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let univLabel: UILabel = UILabel()
    private let line: UIView = UIView()
    
    override func setupStyle() {
        univLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                withText: "서현대학교",
                color: .gray900
            )
        }
        
        line.do {
            $0.backgroundColor = .gray200
        }
    }
    
    override func setupHierarchy() {
        self.addSubviews(univLabel, line)
    }
    
    override func setupLayout() {
        univLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview()
        }
        
        line.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
