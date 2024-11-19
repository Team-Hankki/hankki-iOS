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
        view.backgroundColor = .white
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .gray600
        tabBar.tintColor = .black
        
        tabBar.do {
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.05
            $0.layer.shadowOffset = CGSize(width: 0, height: 1)
            $0.layer.shadowRadius = 24
            
            let customBorder = CALayer()
            customBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1)
            customBorder.backgroundColor = UIColor.gray100.cgColor
            
            $0.layer.addSublayer(customBorder)
        }
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
            .font: UIFont.setupSuiteStyle(of: .caption) as Any,
            .foregroundColor: UIColor.gray400
        ]
        
        // title이 선택되었을 때 폰트, 색상 설정
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.setupSuiteStyle(of: .caption) as Any,
            .foregroundColor: UIColor.red500
        ]
        
        tabbarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        tabbarItem.setTitleTextAttributes(normalAttributes, for: .normal)
        tabbarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        currentViewController.tabBarItem = tabbarItem
        
        return currentViewController
    }
}

/// Custom Tab Bar
final class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height += 14
        return size
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let index = viewControllers?.firstIndex(of: viewController) else { return true }
        
        let tabBarItem = TabBarItem.allCases[index]
        SetupAmplitude.shared.logEvent(tabBarItem.amplitudeButtonName)
        
        switch tabBarItem {
        case .report:
            if UserDefaults.standard.getUniversity()?.id == nil {
                self.showAlert(titleText: StringLiterals.Alert.selectUniversityFirst, primaryButtonText: StringLiterals.Alert.check)
            } else {
                navigationController?.pushViewController(TabBarItem.report.targetViewController, animated: true)
            }
            return false
        case .mypage:
            if !UserDefaults.standard.isLogin {
                self.showAlert(titleText: StringLiterals.Alert.Browse.title,
                               secondaryButtonText: StringLiterals.Alert.Browse.secondaryButton,
                               primaryButtonText: StringLiterals.Alert.Browse.primaryButton,
                               primaryButtonHandler: { UIApplication.browseApp() })
                return false
            }
            return true
        default:
            return true
        }
    }
}
