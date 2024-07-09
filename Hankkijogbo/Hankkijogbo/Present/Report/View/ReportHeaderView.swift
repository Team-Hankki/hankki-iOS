//
//  ReportHeaderView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/10/24.
//

import UIKit

final class ReportHeaderView: BaseCollectionReusableView {
    
    // MARK: - UI Properties
    
    private let headerLabel = UILabel()
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        self.addSubview(headerLabel)
    }
    
    override func setupLayout() {
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        headerLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle1,
                withText: "식당 종류를 알려주세요",
                color: .gray900
            )
        }
    }
}
