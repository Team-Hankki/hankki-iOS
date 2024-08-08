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
    func getMe() {
        NetworkService.shared.userService.getMe { result in
            result.handleNetworkResult(result) { response in
                self.userInfo = MypageHeaderView.Model(image: response.data.profileImageUrl,
                                                       name: response.data.nickname)
            }
        }
    }
    
    func patchLogout() {
        NetworkService.shared.authService.patchLogout { result in
           result.handleNetworkResult(result) { _ in
               print("🛠️ RESTART APPLICATION 🛠️ - LOGOUT")
               UIApplication.resetApp()
           }
       }
   }
    
    func deleteWithdraw(authorizationCode: String) {
        NetworkService.shared.authService.deleteWithdraw(authorizationCode: authorizationCode) { result in
            result.handleNetworkResult(result, onSuccessVoid: {
                print("🛠️ RESTART APPLICATION 🛠️ - WITHDRAW")
                UIApplication.resetApp()
            })
        }
    }
}
