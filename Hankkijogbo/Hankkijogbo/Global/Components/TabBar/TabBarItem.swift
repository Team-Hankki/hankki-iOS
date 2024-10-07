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
            return .icReportNormal
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
            return .icReportSelected
        case .mypage:
            return .icMypageSelected
        }
    }
    
    // 탭 별 제목
    var itemTitle: String? {
        switch self {
        case .home: return "가게"
        case .report: return "제보하기"
        case .mypage: return "마이"
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
        case .home: return AmplitudeLiterals.Tabbar.tabHome
        case .report: return AmplitudeLiterals.Tabbar.tabReport
        case .mypage: return AmplitudeLiterals.Tabbar.tabMypage
        }
    }
}
