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
    
//    var userInfo: MypageHeaderView.Model? {
//        didSet {
//            self.reloadCollectionView?()
//        }
//    }
}

extension MypageViewModel {
    
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
            result.handleNetworkResult(onSuccessVoid: {
                print("🛠️ RESTART APPLICATION 🛠️ - WITHDRAW")
                UIApplication.resetApp()
            })
        }
    }
}
