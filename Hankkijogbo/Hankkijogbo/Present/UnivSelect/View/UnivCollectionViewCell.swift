//
//  UnivSelectUnivCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import UIKit

final class UnivCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                univLabel.attributedText = UILabel.setupAttributedText(for: PretendardStyle.subtitle3, 
                                                                       withText: univLabel.text ?? "",
                                                                       color: .red500)
            } else {
                univLabel.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body1, 
                                                                       withText: univLabel.text ?? "",
                                                                       color: .gray800)
            }
        }
    }

    // MARK: - UI Properties
    
    private let univLabel: UILabel = UILabel()
    private let line: UIView = UIView()

    override func setupStyle() {
        univLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                color: .gray800
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
            $0.leading.equalToSuperview().inset(8)
        }
        
        line.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

extension UnivCollectionViewCell {
    func dataBind(_ univText: String, isFinal: Bool) {
        univLabel.text = univText
    
        line.do {
            $0.isHidden = isFinal
        }
    }
}
