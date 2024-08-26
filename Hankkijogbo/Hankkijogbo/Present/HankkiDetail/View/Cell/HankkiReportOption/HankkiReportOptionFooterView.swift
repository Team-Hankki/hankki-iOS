//
//  HankkiReportOptionFooterView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiReportOptionFooterView: BaseCollectionReusableView {
    
    // MARK: - UI Components
    
    let hankkiReportButton: MainButton = MainButton(titleText: StringLiterals.Common.report, isValid: false)
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubview(hankkiReportButton)
    }
    
    override func setupLayout() {
        hankkiReportButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(155)
            $0.height.equalTo(54)
        }
    }
}
