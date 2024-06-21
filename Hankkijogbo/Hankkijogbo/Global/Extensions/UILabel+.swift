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
}
