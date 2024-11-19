//
//  UIFont+.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/1/24.
//

import UIKit

protocol FontStyle {
    var rawValue: String { get }
    var size: CGFloat { get }
    var lineHeight: CGFloat { get }
}

enum PretendardStyle: FontStyle {
    case h1, h2
    case subtitle1, subtitle2, subtitle3
    case body1, body2, body3, body4, body5, body6, body7, body8
    case button
    case caption1, caption2
    
    var rawValue: String {
        switch self {
        case .h1, .h2, .body4:
            return "Pretendard-Bold"
        case .subtitle1, .subtitle2, .subtitle3, .body2, .body5, .body7:
            return "Pretendard-SemiBold"
        case .body1, .body3, .body6, .body8, .caption1:
            return "Pretendard-Medium"
        case .button, .caption2:
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
        case .body3, .body2:
            return 15
        case .body4, .body5, .body6:
            return 14
        case .body7, .body8:
            return 13
        case .button, .caption1:
            return 12
        case .caption2:
            return 11
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        default:
            return 1.5
        }
    }
}

enum SuiteStyle: FontStyle {
    case h1, h2, h3
    case subtitle1, subtitle2, subtitle3
    case body1, body2, body3, body4
    case caption
    
    var rawValue: String {
        switch self {
        case .h1, .h2, .h3, .subtitle1, .subtitle3, .caption:
            return "SUITE-Bold"
        case .subtitle2, .body3:
            return "SUITE-SemiBold"
        case .body1, .body4:
            return "SUITE-Medium"
        case .body2:
            return "SUITE-Regular"
        }
    }
    
    var size: CGFloat {
        switch self {
        case .h1:
            return 24
        case .h2:
            return 20
        case .h3:
            return 18
        case .subtitle1:
            return 17
        case .subtitle2, .body1:
            return 16
        case .subtitle3:
            return 15
        case .body2, .body3:
            return 14
        case .body4:
            return 13
        case .caption:
            return 10
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .subtitle3:
            return 1.4
        default:
            return 1.5
        }
    }
}

extension UIFont {
    static func setupPretendardStyle(of style: PretendardStyle) -> UIFont? {
        return UIFont(name: style.rawValue, size: style.size)
    }
    
    static func setupSuiteStyle(of style: SuiteStyle) -> UIFont? {
        return UIFont(name: style.rawValue, size: style.size)
    }
}
