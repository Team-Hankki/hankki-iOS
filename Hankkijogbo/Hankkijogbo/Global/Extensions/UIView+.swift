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
    
    /// UIView 의 모서리가 둥근 정도를 설정
    /// - Parameter radius: radius 값
    /// - Parameter maskedCorners: radius를 적용할 코너 지정
    func makeRounded(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    /// 애니메이션과 함께 뷰를 제거한다.
    func removeViewWithAnimation(duration: Double = 0.5, delay: Double = 2) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveEaseIn,
                       animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    /// 파라미터 값에 맞는 Shadow를 추가한다.
    func addShadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
    }
    
    /// width 기준으로 종횡비를 유지해  view의 CGsize를 계산하는 함수
    static func convertByAspectRatioHeight(_ newWidth: CGFloat, width: CGFloat, height: CGFloat) -> CGFloat {
        let newHeight: CGFloat = newWidth / width * height
        return newHeight
    }
}
