//
//  CATransition+.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/16/24.
//

import UIKit

extension CATransition {
    /// - 화면 이동 시 fade out 효과
    func fadeTransition(duration: Double) -> CATransition {
        let transition = CATransition()
        transition.duration = duration
        transition.type = CATransitionType.fade
        return transition
    }
}
