//
//  MypageViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation
import UIKit

final class MypageViewModel {
    
    var reloadCollectionView: (() -> Void)?
    
    var userInfo: MypageHeaderView.DataStruct? {
        didSet {
            self.reloadCollectionView?()
        }
    }
}

extension MypageViewModel {
    func getMe() {
        NetworkService.shared.userService.getMe { result in
            result.handleNetworkResult(result) { response in
                self.userInfo = MypageHeaderView.DataStruct(image: response.data.profileImageUrl,
                                                            name: response.data.nickname)
            }
        }
    }
    
    func patchLogout() {
        NetworkService.shared.authService.patchLogout { [self] result in
           result.handleNetworkResult(result) { response in
               resetApp()
           }
       }
   }
    
    func deleteWithdraw(authorizationCode: String) {
        NetworkService.shared.authService.deleteWithdraw(authorizationCode: authorizationCode) { [self] result in
            result.handleNetworkResult(result) { response in
                resetApp()
            }
        }
    }
}

private extension MypageViewModel {
    func resetApp() {
        // 어플리케이션에서 user information 삭제
        UserDefaults.standard.removeUserInformation()
        
        // Splash 화면으로 이동
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    let splashViewController = SplashViewController()
                    window.rootViewController = splashViewController
                }
            }
        }
    }
}
