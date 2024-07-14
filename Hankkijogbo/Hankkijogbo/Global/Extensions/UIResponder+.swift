//
//  UIResponder+.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/14/24.
//

import UIKit

extension UIResponder {

    private struct Static {
        static weak var responder: UIResponder?
    }

    // 현재 응답자를 반환
    static var currentResponder: UIResponder? {
        // 초기화
        Static.responder = nil
        // 특정 동작을 유발시켜서 현재 응답자를 찾아낸다
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        // 찾아낸 응답잔 반환
        return Static.responder
    }

    // 현재 응답자를 저장하는 private 메서드
    @objc private func _trap() {
        Static.responder = self
    }
}
