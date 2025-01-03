//
//  CompleteViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/10/24.
//

import UIKit

// MARK: - 완료 화면

final class CompleteViewController: BaseViewController {
    
    // MARK: - UI Components
    
    private var completeView: MenuCompleteView
    
    // MARK: - Life Cycle
    
    init(completeView: MenuCompleteView) {
        self.completeView = completeView
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.isNavigationBarHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.isNavigationBarHidden = false
        }
    }
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        view.addSubviews(
            completeView
        )
    }
    
    override func setupLayout() {
        completeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
