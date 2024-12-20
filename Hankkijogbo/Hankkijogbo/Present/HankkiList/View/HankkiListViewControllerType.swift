//
//  HankkiListViewControllerType.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/11/24.
//

import UIKit

extension BaseHankkiListViewController {
    enum HankkiListViewControllerType {
        case reported
        case liked
        
        var navigationTitle: String {
            switch self {
            case .reported:
                StringLiterals.Mypage.HankkiList.reported
            case .liked:
                StringLiterals.Mypage.HankkiList.liked
            }
        }
        
        var emptyViewLabel: String {
            switch self {
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
            }
        }
    }
    
    enum ZipDetailCollectionViewType {
        case myZip
        case sharedZip
        
        var navigationTitle: String {
            switch self {
            case .myZip:
                StringLiterals.Mypage.myZipList
            case .sharedZip:
                StringLiterals.SharedZip.navigation
            }
        }
        
        var isAddZipButton: Bool {
            switch self {
            case .sharedZip:
                true
            default :
                false
            }
        }
    }
}
