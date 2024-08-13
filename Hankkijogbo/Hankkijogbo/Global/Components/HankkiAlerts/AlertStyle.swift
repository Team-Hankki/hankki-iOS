//
//  AlertType.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import UIKit

struct AlertStyle {
    var alertCornerRadius: CGFloat
    var alertStackViewSpacing: CGFloat
    let titleFont: FontStyle
    var labelStackViewAlignment: UIStackView.Alignment
    var labelAlignment: NSTextAlignment
    var buttonStackViewAlignment: UIStackView.Alignment
    
    static let textAlertStyle = AlertStyle(
        alertCornerRadius: 24,
        alertStackViewSpacing: 16,
        titleFont: PretendardStyle.subtitle1,
        labelStackViewAlignment: .leading,
        labelAlignment: .left,
        buttonStackViewAlignment: .trailing
    )
    
    static let imageAlertStyle = AlertStyle(
        alertCornerRadius: 32,
        alertStackViewSpacing: 26,
        titleFont: PretendardStyle.subtitle3,
        labelStackViewAlignment: .center,
        labelAlignment: .center,
        buttonStackViewAlignment: .center
    )
}
