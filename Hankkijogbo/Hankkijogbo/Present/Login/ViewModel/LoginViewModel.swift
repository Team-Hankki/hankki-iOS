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
//    func getUniversity() {
//        UserDefaults.standard.removeUniversity()
//        
//        NetworkService.shared.userService.getMeUniversity { result in
//            switch result {
//            case .notFound:
//                let university: UniversityModel = UniversityModel(id: nil,
//                                                                  name: "전체",
//                                                                  longitude: 0.0,
//                                                                  latitude: 0.0)
//                UserDefaults.standard.saveUniversity(university)
//            default:
//                result.handleNetworkResult { response in
//                    let university: UniversityModel = UniversityModel(id: response.data.id,
//                                                                      name: response.data.name,
//                                                                      longitude: response.data.longitude,
//                                                                      latitude: response.data.latitude)
//                    UserDefaults.standard.saveUniversity(university)
//                }
//            }
//        }
//    }
    
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
                        self.presentNextView(response.data.isRegistered)
                    }
                }
            }
        }
    }
}

private extension LoginViewModel {
    func presentNextView(_ isRegistered: Bool) {
        DispatchQueue.main.async {
            if isRegistered {
                // isRegistered -> true ( 로그인 )
                // -> 사용자의 대학정보 가져오기
                // -> 홈 뷰로 이동
                self.getUniversity {
                    self.presentHomeView()
                }
            } else {
                // isRegistered -> false ( 회원가입 )
                // -> 온보딩 뷰로 넘어감
                self.presentOnboardingView()
            }
        }
    }
    
    func presentHomeView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                let navigationController = HankkiNavigationController(rootViewController: TabBarController())
                window.rootViewController = navigationController
            }
        }
    }
    
    func presentOnboardingView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController = OnboardingViewController()
            }
        }
    }
}

private extension LoginViewModel {
    func getUniversity(completion: @escaping () -> Void) {
        UserDefaults.standard.removeUniversity()
        
        NetworkService.shared.userService.getMeUniversity { result in
            switch result {
            // 어떠한 이슈로 서버 내에 유저의 대학 정보가 저장되지 않은 경우 '전체'로 기본 값을 설정한다.
            case .notFound:
                self.saveUniversity()
                completion()
            default:
                // 성공한 경우 에러 핸들링
                result.handleNetworkResult { response in
                    self.saveUniversity(id: response.data.id,
                                        name: response.data.name,
                                        longitude: response.data.longitude,
                                        latitude: response.data.latitude)
                    
                    completion()
                }
            }
        }
    }
    
    func saveUniversity(id: Int? = nil, name: String = "전체", longitude: Double = 0.0, latitude: Double = 0.0) {
        let university: UniversityModel = UniversityModel(id: id,
                                                          name: name,
                                                          longitude: longitude,
                                                          latitude: latitude)
        UserDefaults.standard.saveUniversity(university)
    }
}
