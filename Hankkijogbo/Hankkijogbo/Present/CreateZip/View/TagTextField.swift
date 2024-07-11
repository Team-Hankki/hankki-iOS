//
//  TagTextField.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/11/24.
//

import UIKit

class TagTextField: UITextField {

    // 터치 이벤트를 무시하여 드래그 방지
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            return false // 패닝(드래그) 제스처 무시
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}
