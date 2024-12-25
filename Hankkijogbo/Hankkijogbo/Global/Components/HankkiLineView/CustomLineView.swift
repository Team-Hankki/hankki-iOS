//
//  GrayLineView.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 12/22/24.
//

import UIKit

import SnapKit

/// 색상과 높이를 동적으로 설정할 수 있는 Custom Line View
/// default : gray200, height 1
final class CustomLineView: UIView {

    init(frame: CGRect = .zero, backgroundColor: UIColor = .gray200, height: Int = 1) {
        super.init(frame: frame)
        
        setupStyle(backgroundColor: backgroundColor)
        setupLayout(height: height)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupStyle(backgroundColor: .gray200)
        setupLayout(height: 1)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 1)
    }
}

private extension CustomLineView {
    func setupStyle(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
    
    func setupLayout(height: Int) {
        self.snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }
}
