//
//  HankkiDetailViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/18/24.
//

import Foundation

import Moya

final class HankkiDetailViewModel {
    
    /// 식당 세부 조회
    func getHankkiDetailAPI(completion: @escaping (Bool) -> Void) {
        NetworkService.shared.hankkiService.getHankkiDetail(id: 19) { [weak self] result in
            switch result {
            case .success(let response):
                print(response?.data)
                completion(true)
                print("SUCCESS")
                print()
            case .unAuthorized, .networkFail:
                completion(false)
                print("FAILED")
            default:
                return
            }
        }
    }
    
}
