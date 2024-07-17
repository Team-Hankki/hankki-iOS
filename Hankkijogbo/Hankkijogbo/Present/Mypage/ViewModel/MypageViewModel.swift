//
//  MypageViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation
import UIKit

final class MypageViewModel {
    
}

extension MypageViewModel {
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
                // TODO: - Error 처리하기
                print("레전드 에러발생")
            default:
                return
            }
        }
    }
}
