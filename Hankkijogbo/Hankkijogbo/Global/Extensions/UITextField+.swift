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
    
    /// 텍스트필드의 border의 가시성을 변경하는 함수
    /// - isVisible이 true면 border가 보이고 false면 보이지 않는다
    final func changeBorderVisibility(isVisible: Bool, color: CGColor) {
        self.layer.borderWidth = isVisible ? 1 : 0
        self.layer.borderColor = color
    }
}
