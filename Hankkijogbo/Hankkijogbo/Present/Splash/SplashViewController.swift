//
//  SplashViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import UIKit

final class SplashViewController: BaseViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isLogin() {
            getUniversity()
        } else {
            presentOnboardingView()
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .yellow
    }
}

private extension SplashViewController {
    func isLogin() -> Bool {
        return !UserDefaults.standard.getAccesshToken().isEmpty
    }
    
    func presentHomeView() {
        let navigationController = HankkiNavigationController(rootViewController: TabBarController())
        self.view.window?.rootViewController = navigationController
        navigationController.popToRootViewController(animated: false)
    }
    
    func presentOnboardingView() {
        self.view.window?.rootViewController = OnboardingViewController()
    }
}

extension SplashViewController {
    func getUniversity() {
        print("개큰 스플레시 시작")
        // 사용자의 대학을 조회한다.
        NetworkService.shared.userService.getMeUniversity { result in
            switch result {
            case .success(let response):
                // 사용자 대학 있음
                // 로컬에 대학 정보 저장
                if let university = response?.data {
                    let university: UniversityModel = UniversityModel(id: university.id,
                                                                      name: university.name,
                                                                      longitude: university.longitude,
                                                                      latitude: university.latitude)
                    UserDefaults.standard.saveUniversity(university)
                }
                
            case .notFound: 
                // 사용자 대학 없음.
                UserDefaults.standard.removeUniversity()
            case .unAuthorized:
                // Access Token 만료
                // Access Token을 다시 발급 받기 위해 reissue API 를 호출한다.
                if !UserDefaults.standard.getAccesshToken().isEmpty { self.postReissue() }
            
            default:
                print("로그인 중 나약한 개발자의 힘으로는 해결할 수 없는 레전드 에러 발생", result)
                return
            }
            
            self.presentHomeView()
        }
    }
    
    func postReissue() {
        NetworkService.shared.authService.postReissue { result in
            switch result {
            case .success(let response):
                // Refresh Token 발급 완료
                let accessToken = response?.accessToken ?? ""
                let refreshToken = response?.refreshToken ?? ""
                UserDefaults.standard.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
    
            case .unAuthorized:
                // Refresh Token 만료
                // Refresh, Access Token을 다시 발급 받기 위해 로그인 창으로 돌아간다.
                UserDefaults.standard.removeTokens()
                self.presentOnboardingView()
                return
            
            default:
                print("리프레시 토큰을 겟하는 중 나약한 개발자의 힘으로는 해결할 수 없는 레전드 에러 발생", result)
                return
            }
        }
    }
}
