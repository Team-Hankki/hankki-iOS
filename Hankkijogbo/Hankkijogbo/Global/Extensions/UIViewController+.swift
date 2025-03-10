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
    
    /// - 키보드 올라올 때와 내려갈 때 Observer 등록
    func setUpKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// - 키보드가 올라올 때 키보드가 텍스트필드 가리면 뷰의 높이를 올려주는 동작이 들어있습니다.
    @objc func keyboardWillShow(_ sender: Notification) {
        // keyboardFrame : 현재 동작하고 있는 이벤트에서 키보드의 frame을 받아옴
        // currentTextField : 현재 응답을 받고 있는 UITextField를 확인한다.
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, let currentTextField = UIResponder.currentResponder as? UITextField else { return }
        
        // 키보드 상단의 y값 (= 높이)
        let keyboardYTop = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldYBottom = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
        
        // textField 하단의 y축 값이 키보드 상단의 y축 값보다 클 때 (= 키보드가 textField를 가릴 때)
        if textFieldYBottom > keyboardYTop {
            let textFieldYTop = convertedTextFieldFrame.origin.y
            let properTextFieldHight = textFieldYTop - keyboardYTop/1.3
            // view의 y값 변경
            view.frame.origin.y = -properTextFieldHight
        }
    }
    
    /// - 키보드가 내려갈 때 뷰의 y값 돌려놓기
    @objc func keyboardWillHide(_ sender: Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    
    /// Alert을 띄우는 메서드
    func showAlert(
        image: UIImage? = nil,
        titleText: String,
        subText: String = "",
        secondaryButtonText: String = "",
        primaryButtonText: String,
        secondaryButtonHandler: (() -> Void)? = nil,
        primaryButtonHandler: (() -> Void)? = nil,
        hightlightedText: String = "",
        hightlightedColor: UIColor? = nil
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
        if hightlightedColor != nil {
            alert.setupHighlightedTitle(start: 0,
                                     end: hightlightedText.count,
                                     color: hightlightedColor ?? .red500)
        }
    }
    
    /// 하단에 뜨는 검정 토스트뷰를 띄우는 함수
    func showBlackToast(
        message: String,
        action: (() -> Void)? = nil
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
    
    /// 나의 식당 족보 바텀 시트 띄우기
    func presentMyZipListBottomSheet(id: Int) {
        let viewController = MyZipListBottomSheetViewController(storeId: id)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen        
        self.present(viewController, animated: false, completion: nil)
    }
    
    /// - ViewController를 dismiss 할 때 fade out 효과를 주는 함수
    func dismissWithFadeOut() {
        let transition = CATransition().fadeTransition(duration: 0.2)
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 한끼 네비로 세팅한 후 식당 상세로 push
    func pushToDetailWithHankkiNavigation(hankkiId: Int) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController as? HankkiNavigationController {
            let type: HankkiNavigationType = HankkiNavigationType(hasBackButton: true,
                                                                  hasRightButton: false,
                                                                  mainTitle: .string(""),
                                                                  rightButton: .string(""))
            rootViewController.setupNavigationBar(forType: type)
            rootViewController.isNavigationBarHidden = false
            
            let hankkiDetailViewController = HankkiDetailViewController(viewModel: HankkiDetailViewModel(hankkiId: hankkiId))
            rootViewController.pushViewController(hankkiDetailViewController, animated: true)
        }
    }
}
