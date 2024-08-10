//
//  UIView+.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import UIKit

extension UIView {
    
    /// 한 번에 여러 개의 UIView 또는 UIView의 하위 클래스 객체들을 상위 UIView에 추가
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    /// UIView 의 모서리의 색상, 모서리 두께, 둥근 정도
    func makeRoundBorder(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor ) {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    /// 애니메이션과 함께 뷰를 제거한다.
    func removeViewWithAnimation(duration: Double = 0.5, delay: Double = 2) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: [.curveEaseIn, .allowUserInteraction],
                       animations: {
            self.alpha = 0.02
        }, completion: { _ in
            self.alpha = 0
            self.removeFromSuperview()
        })
    }
    
    func addShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = alpha
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowRadius = blur / 2.0
        
        if spread == 0 {
            self.layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            self.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    /// width 기준으로 종횡비를 유지해  view의 CGsize를 계산하는 함수
    static func convertByAspectRatioHeight(_ newWidth: CGFloat, width: CGFloat, height: CGFloat) -> CGFloat {
        let newHeight: CGFloat = newWidth / width * height
        return newHeight
    }
}
