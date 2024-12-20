//
//  HankkiListViewControllerType.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/11/24.
//

import UIKit

extension BaseHankkiListViewController {
    enum HankkiListViewControllerType {
        case myZip
        case sharedZip
        case reported
        case liked
 
        var navigationTitle: String {
            switch self {
            case .myZip:
                StringLiterals.Mypage.myZipList
            case .reported:
                StringLiterals.Mypage.HankkiList.reported
            case .liked:
                StringLiterals.Mypage.HankkiList.liked
            case .sharedZip:
                <#code#>
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
