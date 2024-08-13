//
//  TabBarController.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/5/24.
//

import UIKit

import SnapKit
import Then

// MARK: - Tab Bar

final class TabBarController: UITabBarController {
    
    var customTabBar = CustomTabBar()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValue(customTabBar, forKey: "tabBar")
        
        setupStyle()
        setupDelegate()
        addTabBarController()
    }
}

// MARK: - Private Extensions

private extension TabBarController {
    func setupStyle() {
        view.backgroundColor = .gray
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .gray600
        tabBar.tintColor = .black
    }
    
    func setupDelegate() {
        self.delegate = self
    }
    
    func addTabBarController() {
        let viewControllers = TabBarItem.allCases.map {
            let currentViewController = createViewController(
                title: $0.itemTitle ?? "",
                image: $0.normalItem ?? UIImage(),
                selectedImage: $0.selectedItem ?? UIImage(),
                viewController: $0.targetViewController
            )
            return currentViewController
        }
        setViewControllers(viewControllers, animated: false)
    }
    
    func createViewController(title: String,
                              image: UIImage,
                              selectedImage: UIImage,
                              viewController: UIViewController) -> UIViewController {
        let currentViewController = viewController
        let tabbarItem = UITabBarItem(
            title: title,
            image: image.withRenderingMode(.alwaysOriginal),
            selectedImage: selectedImage.withRenderingMode(.alwaysOriginal)
        )
        
        // title이 선택되지 않았을 때 폰트, 색상 설정
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.setupSuiteStyle(of: .body1) as Any,
            .foregroundColor: UIColor.gray
        ]
        
        // title이 선택되었을 때 폰트, 색상 설정
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.setupSuiteStyle(of: .body1) as Any,
            .foregroundColor: UIColor.black
        ]
        
        tabbarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        tabbarItem.setTitleTextAttributes(normalAttributes, for: .normal)
        tabbarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        currentViewController.tabBarItem = tabbarItem
        
        return currentViewController
    }
}

// Custom Tab Bar
final class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height += 14
        return size
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return true }

        if index == TabBarItem.allCases.firstIndex(of: .report) {
            let reportViewController = ReportViewController()
            navigationController?.pushViewController(reportViewController, animated: true)
            return false
        }

        return true
    }
}
