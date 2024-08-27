//
//  TabBarItem.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/5/24.
//

import UIKit

enum TabBarItem: CaseIterable {
    
    case home, report, mypage

    // 선택되지 않은 탭
    var normalItem: UIImage? {
        switch self {
        case .home:
            return .icHomeNormal
        case .report:
            return .icReport
        case .mypage:
            return .icMypageNormal
        }
    }
    
    // 선택된 탭
    var selectedItem: UIImage? {
        switch self {
        case .home:
            return .icHomeSelected
        case .report:
            return .icReport
        case .mypage:
            return .icMypageSelected
        }
    }
    
    // 탭 별 제목
    var itemTitle: String? {
        switch self {
        case .home: return ""
        case .report: return ""
        case .mypage: return ""
        }
    }
    
    // 탭 별 전환될 화면 -> 나중에 하나씩 추가
    var targetViewController: UIViewController {
        switch self {
        case .home: return HomeViewController()
        case .report: return ReportViewController()
        case .mypage: return MypageViewController()
        }
    }
    
    var amplitudeButtonName: String{
        switch self {
        case .home: return "Tabbar-Home"
        case .report: return "Tabbar-Report"
        case .mypage: return "Tabbar-Mypage"
        }
    }
}
