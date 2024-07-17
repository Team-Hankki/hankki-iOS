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
            print("리로드 시작🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥")
            self.reloadCollectionView?()
        }
    }
}

extension HankkiListViewModel {
    func getMeHankkiList(_ type: UserTargetType, completion: @escaping (Bool) -> Void) {
        NetworkService.shared.userService.getMeHankkiList(type) { result in
            print("switch result", result)
            switch result {
            case .success(let response):
                print("switch result-2")
                if let responseData = response {
                    print("switch result-3")
                    self.hankkiList = responseData.data.stores.map {
                        print("switch result-4")
                        return HankkiListTableViewCell.DataStruct(id: $0.id,
                                                                  name: $0.name,
                                                                  imageURL: $0.imageUrl,
                                                                  category: $0.category,
                                                                  lowestPrice: $0.lowestPrice,
                                                                  heartCount: $0.heartCount)
                    }
                } else { print("레전드 오류 발생") }
//                completion(true)
            case .unAuthorized, .networkFail:
                print("Failed to fetch university list.")
//                completion(false)
            default:
                return
//                completion(false)
            }
        }
    }
}
