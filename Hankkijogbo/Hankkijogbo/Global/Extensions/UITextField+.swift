//
//  UITextField+.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import UIKit

extension UITextField {
    
    /// 텍스트필드 안쪽에 패딩 추가
    func addPadding(left: CGFloat? = nil, right: CGFloat? = nil) {
        if let left {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: 0))
            leftViewMode = .always
        }
        if let right {
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: 0))
            rightViewMode = .always
        }
    }
    
    /// Placeholder의 색상을 바꿔주는 메서드
    func changePlaceholderColor(forPlaceHolder: String, forColor: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: forPlaceHolder, attributes: [NSAttributedString.Key.foregroundColor: forColor])
    }
    
    /// TextField에 이모지를 받지 않는 함수 -> 이모지 클릭해도 작성 안 됨
    /// shouldChangeCharactersIn 함수 내에서 쓰면 됨
    /// - shouldChangeCharactersIn range: NSRange
    /// - replacementString string: String
    func disableEmojiText(range: NSRange, string: String) -> Bool {
        let utf8Char = string.cString(using: .utf8)
        let isBackSpace = strcmp(utf8Char, "\\b")
        if string.hasCharacters() || isBackSpace == -92 {
            guard let textFieldText = self.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 300
        }
        return false
    }
}
