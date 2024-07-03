//
//  UIFont+.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/1/24.
//

import UIKit

enum FontStyle {
    case h1
    case h2
    case subtitle1
    case subtitle2
    case subtitle3
    case body1
    case body2
    case body3
    case body4
    case body5
    case button
    case caption1
    case caption2
}

enum FontName: String {
    case pretendardBold = "Pretendard-Bold"
    case pretendardSemiBold = "Pretendard-SemiBold"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardRegular = "Pretendard-Regular"
    case suitBold = "SUIT-Bold"
    case suitSemiBold = "SUIT-SemiBold"
    case suitMedium = "SUIT-Medium"
    case suitRegular = "SUIT-Regular"
}

extension UIFont {
    static func setupFontStyle(of style: FontStyle) -> UIFont? {
        let size: CGFloat
        let fontName: String
        
        switch style {
        case .h1:
            size = 24
            fontName = FontName.pretendardBold.rawValue
        case .h2:
            size = 20
            fontName = FontName.pretendardBold.rawValue
        case .subtitle1:
            size = 18
            fontName = FontName.pretendardSemiBold.rawValue
        case .subtitle2:
            size = 17
            fontName = FontName.pretendardSemiBold.rawValue
        case .subtitle3:
            size = 16
            fontName = FontName.pretendardSemiBold.rawValue
        case .body1:
            size = 16
            fontName = FontName.pretendardMedium.rawValue
        case .body2:
            size = 14
            fontName = FontName.pretendardBold.rawValue
        case .body3:
            size = 14
            fontName = FontName.pretendardSemiBold.rawValue
        case .body4:
            size = 14
            fontName = FontName.pretendardRegular.rawValue
        case .body5:
            size = 13
            fontName = FontName.pretendardRegular.rawValue
        case .button:
            size = 12
            fontName = FontName.pretendardRegular.rawValue
        case .caption1:
            size = 12
            fontName = FontName.pretendardMedium.rawValue
        case .caption2:
            size = 11
            fontName = FontName.pretendardRegular.rawValue
        }
        
        return UIFont(name: fontName, size: size)
    }
}
