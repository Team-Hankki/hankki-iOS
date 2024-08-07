//
//  LoginViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation
import UIKit

final class LoginViewModel { }

extension LoginViewModel {
    func postLogin (accessToken: String, postLoginRequest: PostLoginRequestDTO) {
        NetworkService.shared.authService.postLogin(accessToken: accessToken, requestBody: postLoginRequest) { result in
            result.handleNetworkResult(result) { response in
                let refreshToken = response.data.refreshToken
                let accessToken = response.data.accessToken
                
                UserDefaults.standard.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                
                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        if let window = windowScene.windows.first {
                            if response.data.isRegistered {
                                // isRegistered -> true ( 로그인 )
                                // -> 홈 뷰로 넘어감
                                let navigationController = HankkiNavigationController(rootViewController: TabBarController())
                                window.rootViewController = navigationController
                            } else {
                                // isRegistered -> false ( 회원가입 )
                                // -> 대학 선택 뷰로 넘어감
                                let navigationController = HankkiNavigationController(rootViewController: TabBarController())
                                window.rootViewController = navigationController
                                navigationController.pushViewController(UnivSelectViewController(), animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
}
