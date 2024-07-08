//
//  UIScreen+.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/8/24.
//

import UIKit

extension UIScreen {
    
    // MARK: - 기기 대응
    
    /// 노치가 있는지 없는지 Bool 값 반환
    static var hasNotch: Bool {
        return !( (self.main.bounds.width / self.main.bounds.height) > 0.5 )
    }
    
    static func getDeviceWidth() -> CGFloat {
        return self.main.bounds.width
    }
    
    static func getDeviceHeight() -> CGFloat {
        return self.main.bounds.height
    }
}

extension UIScreen {
    /// 아이폰 13 미니(width 375)를 기준으로 레이아웃을 잡고, 기기의 width 사이즈를 곱해 대응 값을 구할 때 사용
    static func convertByWidthRatio(_ convert: CGFloat) -> CGFloat {
        return convert * (getDeviceWidth() / 375)
    }
    
    /// 아이폰 13 미니(height 812)를 기준으로 레이아웃을 잡고, 기기의 height 사이즈를 곱해 대응 값을 구할 때 사용
    static func convertByHeightRatio(_ convert: CGFloat) -> CGFloat {
        return convert * (getDeviceHeight() / 812)
    }
    
    /// 아이폰 13 미니(width 375)를 기준으로 레이아웃을 잡고, 기기의 width 사이즈를 곱해 대응 값을 구할 때 사용
    static func convertByReverseWidthRatio(_ convert: CGFloat) -> CGFloat {
        return convert * (375 / getDeviceWidth())
    }
    
    /// 아이폰 13 미니(height 812)를 기준으로 레이아웃을 잡고, 기기의 height 사이즈를 곱해 대응 값을 구할 때 사용
    static func convertByReverseHeightRatio(_ convert: CGFloat) -> CGFloat {
        return convert * (812 / getDeviceHeight())
    }
}
