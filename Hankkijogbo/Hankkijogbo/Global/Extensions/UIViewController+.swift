//
//  UIViewController+.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import UIKit

extension UIViewController {
    
    /// 네비게이션바를 숨기는 메서드
    func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /// 숨긴 네비게이션 바를 보이게 하는 메서드
    func showNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    /// 화면 밖 터치시 키보드를 내려 주는 메서드
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func changeStatusBarBgColor(statusBarColor: UIColor?) {
        guard #available(iOS 13.0, *) else {
            guard let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView else { return }
            statusBar.backgroundColor = statusBarColor
            return
        }
        
        guard let window = UIApplication.shared.windows.first,
              let statusBarManager = window.windowScene?.statusBarManager else { return }
        
        let statusBarView = UIView(frame: statusBarManager.statusBarFrame)
        statusBarView.backgroundColor = statusBarColor
        window.addSubview(statusBarView)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    
    /// Alert을 띄우는 메서드
    func showAlert(
        image: String = "",
        titleText: String,
        subText: String = "",
        secondaryButtonText: String = "",
        primaryButtonText: String,
        secondaryButtonHandler: (() -> Void)? = nil,
        primaryButtonHandler: (() -> Void)? = nil
    ) {
        let alert = AlertViewController()
        alert.modalPresentationStyle = .overFullScreen
        alert.do {
            $0.image = image
            
            $0.titleText = titleText
            $0.subText = subText
            
            $0.secondaryButtonText = secondaryButtonText
            $0.primaryButtonText = primaryButtonText
            
            $0.secondaryButtonHandler = secondaryButtonHandler
            $0.primaryButtonHandler = primaryButtonHandler
        }
        present(alert, animated: false, completion: nil)
    }
    
    /// 하단에 뜨는 검정 토스트뷰를 띄우는 함수
    func showBlackToast(
        message: String,
        action: @escaping (() -> Void)
    ) {
        let toastView = BlackToastView(message: message, action: action)
        view.addSubview(toastView)
        if UIScreen.hasNotch {
            toastView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            }
        } else {
            toastView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(16)
            }
        }
    }
    
    /// 상단에 뜨는 흰 토스트뷰를 띄우는 함수
    func showWhiteToast(
        message: String,
        action: @escaping (() -> Void)
    ) {
        let toastView = WhiteToastView(message: message, action: action)
        view.addSubview(toastView)
        if UIScreen.hasNotch {
            toastView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            }
        } else {
            toastView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().inset(35)
            }
        }
    }
    
    /// UISheetPresentationController를 통해 ViewController를 Sheet 형태로 present할 때 사용한다.
    /// - detents의 기본값 : medium, large -> sheet가 중간 및 최대 높이를 가질 수 있게 설정
    func showSheetPresentation(
        _ viewController: UIViewController,
        detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
        cornerRadius: CGFloat = 32
    ) {
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = detents
            sheet.preferredCornerRadius = cornerRadius
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }

        present(viewController, animated: true, completion: nil)
    }
}
