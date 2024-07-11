//
//  HankkiListViewControllerType.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/11/24.
//

import UIKit

extension HankkiListViewController {
    enum HankkiListViewControllerType {
        case myZip
        case repoted
        case liked
        
        var navigationColor: UIColor {
            switch self {
            case .myZip:
                .hankkiRed
            case .repoted, .liked:
                .white
            }
        }
        var tableViewHeight: CGFloat {
            switch self {
            case .myZip:
                UIView.convertByAspectRatioHeight(
                    UIScreen.getDeviceWidth() - 22 * 2,
                    width: 329,
                    height: 231
                ) + 22
                
            case .repoted, .liked:
                0
            }
        }
        
        var navigationTitle: String {
            switch self {
            case .myZip:
                "나의 식당 족보"
            case .repoted:
                "내가 제보한 식당"
            case .liked:
                "좋아요 누른 식당"
            }
        }
    }
}
