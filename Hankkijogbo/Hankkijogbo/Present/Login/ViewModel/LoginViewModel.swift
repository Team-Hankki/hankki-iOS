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
    func getUniversity() {
        UserDefaults.standard.removeUniversity()
        
        NetworkService.shared.userService.getMeUniversity { result in
            result.handleNetworkResult { response in
                let university: UniversityModel = UniversityModel(id: response.data.id,
                                                                  name: response.data.name,
                                                                  longitude: response.data.longitude,
                                                                  latitude: response.data.latitude)
                UserDefaults.standard.saveUniversity(university)

                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let window = windowScene.windows.first {
                        let navigationController = HankkiNavigationController(rootViewController: TabBarController())
                        window.rootViewController = navigationController
                    }
                }
            }
        }
    }
    
    func postLogin (accessToken: String, postLoginRequest: PostLoginRequestDTO) {
        NetworkService.shared.authService.postLogin(accessToken: accessToken, requestBody: postLoginRequest) { result in
            result.handleNetworkResult { response in
                let refreshToken = response.data.refreshToken
                let accessToken = response.data.accessToken
                
                UserDefaults.standard.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                
                // TODO: - 서현) api 호출 안에 api 호출... 코드 고민 해보기
                NetworkService.shared.userService.getMe { result in
                    result.handleNetworkResult { res in
                        UserDefaults.standard.saveNickname(res.data.nickname)
                        
                        DispatchQueue.main.async {
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                if let window = windowScene.windows.first {
                                    if response.data.isRegistered {
                                        // isRegistered -> true ( 로그인 )
                                        // -> 사용자의 대학정보 가져오기
                                        // -> 홈 뷰로 이동
                                        self.getUniversity()
                                    } else {
                                        // isRegistered -> false ( 회원가입 )
                                        // -> 온보딩 뷰로 넘어감
                                        window.rootViewController = OnboardingViewController()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
