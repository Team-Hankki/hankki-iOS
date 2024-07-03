//
//  UIFont+.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/1/24.
//

import UIKit

enum PretendardStyle {
    case h1, h2
    case subtitle1, subtitle2, subtitle3
    case body1, body2, body3, body4, body5
    case button
    case caption1, caption2
    
    var rawValue: String {
        switch self {
        case .h1, .h2, .body2:
            return "Pretendard-Bold"
        case .subtitle1, .subtitle2, .subtitle3, .body3:
            return "Pretendard-SemiBold"
        case .body1, .caption1:
            return "Pretendard-Medium"
        case .body4, .body5, .button, .caption2:
            return "Pretendard-Regular"
        }
    }
    
    var size: CGFloat {
        switch self {
        case .h1:
            return 24
        case .h2:
            return 20
        case .subtitle1:
            return 18
        case .subtitle2:
            return 17
        case .subtitle3, .body1:
            return 16
        case .body2, .body3, .body4:
            return 14
        case .body5:
            return 13
        case .button, .caption1:
            return 12
        case .caption2:
            return 11
        }
    }
}

enum SuitStyle {
    case h1
    case subtitle
    case body1, body2
    
    var rawValue: String {
        switch self {
        case .h1:
            return "SUIT-Bold"
        case .subtitle:
            return "SUIT-SemiBold"
        case .body1:
            return "SUIT-Medium"
        case .body2:
            return "SUIT-Regular"
        }
    }
    
    var size: CGFloat {
        switch self {
        case .h1:
            return 24
        case .subtitle, .body1:
            return 16
        case .body2:
            return 14
        }
    }
}

extension UIFont {
    static func setupPretendardStyle(of style: PretendardStyle) -> UIFont? {
        return UIFont(name: style.rawValue, size: style.size)
    }
    
    static func setupSuitStyle(of style: SuitStyle) -> UIFont? {
        return UIFont(name: style.rawValue, size: style.size)
    }
}
