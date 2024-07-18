//
//  HankkiListViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

final class HankkiListViewModel {
    init() {
        getMe()
    }
    
    var name: String?
    var imageUrl: String?

    var reloadCollectionView: (() -> Void)?
    
    var hankkiList: [HankkiListTableViewCell.DataStruct] = [] {
        didSet {
            self.reloadCollectionView?()
        }
    }
    var zipInfo: ZipHeaderTableView.DataStruct?
}

extension HankkiListViewModel {
    func getMe() {
        NetworkService.shared.userService.getMe { result in
            switch result {
            case .success(let response):
                if let responseData = response {
                    self.name = responseData.data.nickname
                    self.imageUrl = responseData.data.profileImageUrl
                } else { return }
            case .unAuthorized, .pathError:
                print("레전드 에러발생")
            default:
                return
            }
        }
    }
    
    func getZipDetail(zipId: Int, completion: @escaping(Bool) -> Void) {
        NetworkService.shared.zipService.getZipList(zipId: zipId) { result in
            switch result {
            case .success(let response):
                if let responseData = response {
                    self.zipInfo = ZipHeaderTableView.DataStruct(name: self.name ?? "",
                                                                 imageUrl: self.imageUrl ?? "",
                                                                 title: responseData.data.title,
                                                                 details: responseData.data.details)
                    
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
