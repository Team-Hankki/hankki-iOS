//
//  HankkiReportOptionHeaderView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiReportOptionHeaderView: BaseCollectionReusableView {
    
    // MARK: - UI Components
    
    private let headerLabel: UILabel = UILabel()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubview(headerLabel)
    }
    
    override func setupLayout() {
        headerLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        headerLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle1,
                withText: StringLiterals.HankkiDetail.reportWrongInformation,
                color: .gray900
            )
        }
    }
}
