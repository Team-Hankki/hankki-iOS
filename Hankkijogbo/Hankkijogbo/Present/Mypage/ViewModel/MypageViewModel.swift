//
//  MypageViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation
import UIKit

final class MypageViewModel {
    
    var showAlert: ((String) -> Void)?
    
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
            switch result {
            case .success(let response):
                if let responseData = response {
                    self.userInfo = MypageHeaderView.DataStruct(image: responseData.data.profileImageUrl,
                                                name: responseData.data.nickname)
                } else { return }
            case .unAuthorized, .pathError:
                self.showAlert?("Failed")
            default:
                return
            }
        }
    }
    
    func patchLogout() {
        NetworkService.shared.authService.patchLogout { result in
            switch result {
            case .success:
                UserDefaults.standard.removeTokens()
                
                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        if let window = windowScene.windows.first {
                            let splashViewController = SplashViewController()
                            window.rootViewController = splashViewController
                        }
                    }
                }
            case .unAuthorized, .pathError:
                self.showAlert?("Failed")
            default:
                return
            }
        }
    }
    
    func deleteWithdraw(authorizationCode: String) {
        NetworkService.shared.authService.deleteWithdraw(authorizationCode: authorizationCode) { result in
            switch result {
            case .success, .decodeError:
                UserDefaults.standard.removeTokens()
                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        if let window = windowScene.windows.first {
                            let splashViewController = SplashViewController()
                            window.rootViewController = splashViewController
                        }
                    }
                  }
            case .unAuthorized, .pathError:
                self.showAlert?("Failed")
            default:
                return
            }
        }
    }
}
