//
//  HankkiPaddingLabel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

/// - 패딩을 적용할 수 있도록 커스텀한 Label
final class HankkiPaddingLabel: UILabel {
    let padding: UIEdgeInsets

    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
