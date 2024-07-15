//
//  HankkiReportOptionFooterView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiReportOptionFooterView: BaseCollectionReusableView {
    
    // MARK: - UI Components
    
    let hankkiReportButton: MainButton = MainButton(titleText: "제보하기")
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        self.addSubview(hankkiReportButton)
    }
    
    override func setupLayout() {
        hankkiReportButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(155)
            $0.height.equalTo(54)
        }
    }
    
    override func setupStyle() {
        hankkiReportButton.do {
            $0.buttonHandler = hankkiReportButtonDidTap
        }
    }
    
    // MARK: - @objc Func

    @objc func hankkiReportButtonDidTap() {
        print("제보하기 클릭")
    }
}
