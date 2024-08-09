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
        case reported
        case liked
        
        var navigationColor: UIColor {
            switch self {
            case .myZip:
                .hankkiRed
            case .reported, .liked:
                .white
            }
        }
        var headrViewHeight: CGFloat {
            switch self {
            case .myZip:
                UIView.convertByAspectRatioHeight(
                    UIScreen.getDeviceWidth() - 22 * 2,
                    width: 329,
                    height: 231
                ) + 22
                
            case .reported, .liked:
                0
            }
        }
        
        var navigationTitle: String {
            switch self {
            case .myZip:
                StringLiterals.Mypage.myZipList
            case .reported:
                StringLiterals.Mypage.HankkiList.reported
            case .liked:
                StringLiterals.Mypage.HankkiList.liked
            }
        }
        
        var emptyViewLabel: String {
            switch self {
            case .myZip:
                StringLiterals.HankkiList.EmptyView.myZip
            case .reported:
                StringLiterals.HankkiList.EmptyView.reported
            case .liked:
                StringLiterals.HankkiList.EmptyView.liked
            }
        }
        
        var userTargetType: UserTargetType {
            switch self {
            case .reported:
                    .getMeHankkiReportList
            case .liked:
                    .getMeHankkiHeartList
            default:
                    .getMeHankkiHeartList
            }
        }
    }
}
