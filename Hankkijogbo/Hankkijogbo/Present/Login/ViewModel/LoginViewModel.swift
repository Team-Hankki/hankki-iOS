//
//  LoginViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation
import UIKit

final class LoginViewModel {
}

extension LoginViewModel {
    func postLogin (_ postLoginRequest: PostLoginRequestDTO) {
        NetworkService.shared.authService.postLogin(requestBody: postLoginRequest) { result in
            switch result {
            case .success(let response):
                if let responseData = response {
                    let refreshToken = responseData.data.refreshToken
                    let accessToken = responseData.data.accessToken

                    UserDefaults.standard.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
//                    self.onLoginSuccess?(responseData.data.isRegistered)
                    
                    DispatchQueue.main.async {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            if let window = windowScene.windows.first {
                                if responseData.data.isRegistered {
                                    // isRegistered -> true ( 로그인 )
                                    // -> 홈 뷰로 넘어감
                                    let navigationController = HankkiNavigationController(rootViewController: TabBarController())
                                    window.rootViewController = navigationController
                                } else {
                                    // isRegistered -> false ( 회원가입 )
                                    // -> 대학 선택 뷰로 넘어감
                                    let univSelectViewController = UnivSelectViewController()
                                    window.rootViewController = univSelectViewController
                                }
                            }
                        }
                    }
                } else { print("POST LOGIN - response data 없음") }
            case .unAuthorized, .networkFail:
                print("POST LOGIN - 테스트 실패")
            default:
                return
            }
        }
    }
}
