//
//  HankkiDetailHeaderView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiDetailHeaderView: BaseCollectionReusableView {
    
    // MARK: - UI Components
    
    private let headerStackView: UIStackView = UIStackView()
    private let headerLabel: UILabel = UILabel()
    private let categoryLabel: HankkiPaddingLabel = HankkiPaddingLabel()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        self.addSubview(headerStackView)
        headerStackView.addArrangedSubviews(
            headerLabel,
            categoryLabel
        )
    }
    
    override func setupLayout() {
        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.centerX.equalToSuperview()
        }
        headerLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.lessThanOrEqualTo(210)
            $0.height.equalTo(36)
        }
        categoryLabel.snp.makeConstraints {
            $0.centerY.equalTo(headerLabel)
            $0.leading.equalTo(headerLabel.snp.trailing).offset(8)
            $0.height.equalTo(36)
        }
    }
    
    override func setupStyle() {
        headerStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .top
            $0.distribution = .equalSpacing
        }
        categoryLabel.do {
            $0.textColor = .hankkiRed
            $0.backgroundColor = .hankkiRedLight
            $0.makeRounded(radius: 14)
        }
    }
}

extension HankkiDetailHeaderView {
    func dataBind(name: String, category: String) {
        headerLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h1,
                withText: name,
                color: .gray900
            )
            $0.lineBreakMode = .byTruncatingTail // attributedText 설정 이후에 적어야만 적용이 된다고 함
            $0.textAlignment = .center
        }
        categoryLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.caption1,
                withText: category,
                color: .hankkiRed
            )
        }
    }
}
