//
//  TabBarItem.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/5/24.
//

import UIKit

// TODO: - GUI 나오면 이미지 변경

enum TabBarItem: CaseIterable {
    
    case home, report, mypage

    // 선택되지 않은 탭
    var normalItem: UIImage? {
        switch self {
        case .home:
            return .icHeart
        case .report:
            return .icHeart
        case .mypage:
            return .icHeart
        }
    }
    
    // 선택된 탭
    var selectedItem: UIImage? {
        switch self {
        case .home:
            return .icHeart
        case .report:
            return .icHeart
        case .mypage:
            return .icHeart
        }
    }
    
    // 탭 별 제목
    var itemTitle: String? {
        switch self {
        case .home: return "Home"
        case .report: return "Report"
        case .mypage: return "Mypage"
        // case .home: return StringLiterals.TabBar.home 의 형태로 변경
        }
    }
    
    // 탭 별 전환될 화면 -> 나중에 하나씩 추가
    var targetViewController: UIViewController {
        switch self {
        case .home: return ViewController()
        case .report: return ReportViewController()
        case .mypage: return ViewController()
        }
    }
}
