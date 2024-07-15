//
//  HankkiReportOptionCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiReportOptionCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Properties
    
    private var reportOptionLabel: UILabel = UILabel()
    private let radioButton: UIButton = UIButton()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubviews(
            reportOptionLabel,
            radioButton
        )
    }
    
    override func setupLayout() {
        reportOptionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        radioButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.layer.borderColor = UIColor.gray200.cgColor
            $0.layer.borderWidth = 1
            $0.makeRounded(radius: 10)
        }
        reportOptionLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body3,
                withText: "hankkiMenuName",
                color: .gray400
            )
        }
        radioButton.do {
            $0.setImage(.btnRadioNormal, for: .normal)
        }
    }
}
