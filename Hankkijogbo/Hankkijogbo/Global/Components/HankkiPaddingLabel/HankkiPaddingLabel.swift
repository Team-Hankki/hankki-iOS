//
//  HankkiPaddingLabel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

/// - 패딩을 적용할 수 있도록 커스텀한 Label
final class HankkiPaddingLabel: UILabel {
    var padding: UIEdgeInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
