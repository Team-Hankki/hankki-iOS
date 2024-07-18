//
//  HankkiListViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

final class HankkiListViewModel {
    
    var reloadCollectionView: (() -> Void)?
    
    var hankkiList: [HankkiListTableViewCell.DataStruct] = [] {
        didSet {
            self.reloadCollectionView?()
        }
    }
}

extension HankkiListViewModel {
    func getMeHankkiList(_ type: UserTargetType, completion: @escaping (Bool) -> Void) {
        NetworkService.shared.userService.getMeHankkiList(type) { result in
            switch result {
            case .success(let response):
                if let responseData = response {
                    self.hankkiList = responseData.data.stores.map {
                        return HankkiListTableViewCell.DataStruct(id: $0.id,
                                                                  name: $0.name,
                                                                  imageURL: $0.imageUrl,
                                                                  category: $0.category,
                                                                  lowestPrice: $0.lowestPrice,
                                                                  heartCount: $0.heartCount)
                    }
                } else { print("레전드 오류 발생") }
                completion(true)
            case .unAuthorized, .networkFail:
                print("Failed to fetch university list.")
                completion(false)
            default:
                return
            }
        }
    }
}
