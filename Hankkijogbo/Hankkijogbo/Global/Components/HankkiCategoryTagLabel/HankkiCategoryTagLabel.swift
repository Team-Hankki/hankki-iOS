//
//  HankkiCategoryTag.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 8/4/24.
//

import UIKit

class HankkiCategoryTagLabel: UILabel {
    
    private let minimumWidth: CGFloat = 42
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTagStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTagStyle()
    }
    
    // MARK: - Setup Style
    
    private func setupTagStyle() {
        self.makeRoundBorder(cornerRadius: 10, borderWidth: 0, borderColor: .clear)
        self.backgroundColor = .hankkiRedLight
        self.textColor = .hankkiRed
        self.font = .setupPretendardStyle(of: .caption2)
        self.textAlignment = .center
    }
    
    // 글자 수에 따라 tag 사이즈 조정 
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = max(size.width + 20, minimumWidth)
        let height = size.height + 10
        return CGSize(width: width, height: height)
    }
}
