//
//  TagTextField.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/11/24.
//

import UIKit

class TagTextField: UITextField {

    // 터치 이벤트를 무시하여 드래그 방지
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}

extension UITextField {
    // 터치 이벤트를 무시하여 드래그 방지
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}
