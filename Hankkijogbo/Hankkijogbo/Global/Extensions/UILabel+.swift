//
//  UILabel+.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import UIKit

extension UILabel {
    
    /// font 변경
    func asFont(targetString: String, font: UIFont) {
        let originText = text ?? ""
        let attributedString = NSMutableAttributedString(string: originText)
        let range = (originText as NSString).range(of: targetString, options: .caseInsensitive)
        attributedString.addAttribute(.font, value: font, range: range)
        attributedText = attributedString
    }
    
    func asFont(targetStrings: [String], font: UIFont) {
        guard let text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        
        // 대상 문자열들을 반복하여 폰트를 변경
        for targetString in targetStrings {
            let range = (text as NSString).range(of: targetString, options: .caseInsensitive)
            attributedString.addAttribute(.font, value: font, range: range)
        }
        
        attributedText = attributedString
    }
    
    /// color 변경
    func asColor(targetString: String, color: UIColor) {
        let originText = text ?? ""
        let attributedString = NSMutableAttributedString(string: originText)
        let range = (originText as NSString).range(of: targetString)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
    
    /// font, color 둘 다 변경
    func asFontColor(targetString: String, font: UIFont, color: UIColor) {
        let originText = text ?? ""
        let attributedString = NSMutableAttributedString(string: originText)
        let range = (originText as NSString).range(of: targetString)
        attributedString.addAttributes([.font: font as Any, .foregroundColor: color as Any], range: range)
        attributedText = attributedString
    }
    
    /// attributedText를 설정하는 메서드
    static func setupAttributedText<T: FontStyle>(
        for fontName: T,
        withText text: String = "",
        color: UIColor = .gray900
    ) -> NSAttributedString? {
        
        var font: UIFont

        if T.self == PretendardStyle.self {
            font = UIFont.setupPretendardStyle(of: fontName as! PretendardStyle)!
        } else if T.self == SuiteStyle.self {
            font = UIFont.setupSuiteStyle(of: fontName as! SuiteStyle)!
        } else {
            font = UIFont.systemFont(ofSize: 12)
        }
        
        let paragraphStyle = NSMutableParagraphStyle().then {
            $0.minimumLineHeight = fontName.lineHeight * fontName.size
            $0.maximumLineHeight = fontName.lineHeight * fontName.size
        }
        
        let offset = (fontName.lineHeight * fontName.size - fontName.size) / 2
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: offset
        ]
                
        return NSAttributedString(string: text, attributes: attributes)
    }
}
