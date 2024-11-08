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

// MARK: - Private Func

private extension CompleteViewController {
    
    func bindViewModel() {
//        viewModel.updateButton = { isActive in
//            if isActive {
//                self.bottomButtonView.setupEnabledDoneButton()
//            } else {
//                self.bottomButtonView.setupDisabledDoneButton()
//            }
//        }
    }
    
    // MARK: - @objc Func
    
    @objc func completeButtonDidTap() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
