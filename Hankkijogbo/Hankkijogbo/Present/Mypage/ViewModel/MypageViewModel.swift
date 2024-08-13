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
    
    var userInfo: MypageHeaderView.Model? {
        didSet {
            self.reloadCollectionView?()
        }
    }
}

extension MypageViewModel {
    // TODO: - 서현) User 정보 Defaults 에 저장된다면... 수정되어야할 코드
    func getMe() {
        NetworkService.shared.userService.getMe { result in
            result.handleNetworkResult { response in
                self.userInfo = MypageHeaderView.Model(name: response.data.nickname)
            }
        }
    }
    
    func patchLogout() {
        NetworkService.shared.authService.patchLogout { result in
           result.handleNetworkResult { _ in
               print("🛠️ RESTART APPLICATION 🛠️ - LOGOUT")
               UIApplication.resetApp()
           }
       }
   }
    
    func deleteWithdraw(authorizationCode: String) {
        NetworkService.shared.authService.deleteWithdraw(authorizationCode: authorizationCode) { result in
            result.handleNetworkResult { _ in
                print("🛠️ RESTART APPLICATION 🛠️ - WITHDRAW")
                UIApplication.resetApp()
            }
        }
    }
}
