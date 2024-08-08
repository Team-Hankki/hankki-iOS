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
            result.handleNetworkResult { response in
                self.userInfo = MypageHeaderView.DataStruct(image: response.data.profileImageUrl,
                                                            name: response.data.nickname)
            }
        }
    }
    
    func patchLogout() {
        NetworkService.shared.authService.patchLogout { result in
           result.handleNetworkResult { response in
               UIApplication.resetApp()
           }
       }
   }
    
    func deleteWithdraw(authorizationCode: String) {
        NetworkService.shared.authService.deleteWithdraw(authorizationCode: authorizationCode) { result in
            result.handleNetworkResult { response in
                UIApplication.resetApp()
            }
        }
    }
}
