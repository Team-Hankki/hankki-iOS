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
}

extension UIView {
    
    // MARK: - 기기 대응
    
    func getDeviceWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func getDeviceHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// 아이폰 13 미니(width 375)를 기준으로 레이아웃을 잡고, 기기의 width 사이즈를 곱해 대응 값을 구할 때 사용
    func convertByWidthRatio(_ convert: CGFloat) -> CGFloat {
        return convert * (getDeviceWidth() / 375)
    }
    
    /// 아이폰 13 미니(height 812)를 기준으로 레이아웃을 잡고, 기기의 height 사이즈를 곱해 대응 값을 구할 때 사용
    func convertByHeightRatio(_ convert: CGFloat) -> CGFloat {
        return convert * (getDeviceHeight() / 812)
    }
    
    /// 아이폰 13 미니(width 375)를 기준으로 레이아웃을 잡고, 기기의 width 사이즈를 곱해 대응 값을 구할 때 사용
    func convertByReverseWidthRatio(_ convert: CGFloat) -> CGFloat {
        return convert * (375 / getDeviceWidth())
    }
    
    /// 아이폰 13 미니(height 812)를 기준으로 레이아웃을 잡고, 기기의 height 사이즈를 곱해 대응 값을 구할 때 사용
    func convertByReverseHeightRatio(_ convert: CGFloat) -> CGFloat {
        return convert * (812 / getDeviceHeight())
    }
    
    /// 노치가 있는지 없는지 Bool 값 반환
    var hasNotch: Bool {
        return !( (UIScreen.main.bounds.width / UIScreen.main.bounds.height) > 0.5 )
    }
}

extension UIView {
    
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
}
