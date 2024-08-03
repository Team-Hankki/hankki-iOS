//
//  HankkiListViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

final class HankkiListViewModel {
    var showAlert: ((String) -> Void)?
    
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
                self.showAlert?("Failed")
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
                } else { print("Error") }
                completion(true)
            case .unAuthorized, .networkFail:
                self.showAlert?("Failed")
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
                } else { print("오류 발생") }
                completion(true)
            case .unAuthorized, .networkFail:
                self.showAlert?("Failed")
                print("Failed to fetch university list.")
                completion(false)
            default:
                return
            }
        }
    }
    
    func deleteZipToHankki(requestBody: DeleteZipToHankkiRequestDTO, completion: @escaping (Bool) -> Void) {
        NetworkService.shared.zipService.deleteZipToHankki(requestBody: requestBody) { result in
            switch result {
            case .success(_): return
            case .unAuthorized, .pathError:
                self.showAlert?("Failed")
            default:
                return
                
            }
        }
    }
    
    func postHankkiHeartAPI(id: Int64, completion: @escaping () -> Void) {
        NetworkService.shared.hankkiService.postHankkiHeart(id: id) { result in
            switch result {
            case .success(_): return
            case .unAuthorized, .networkFail:
                self.showAlert?("Failed")
            default:
                return
            }
        }
    }
    
    func deleteHankkiHeartAPI(id: Int64, completion: @escaping () -> Void) {
        NetworkService.shared.hankkiService.deleteHankkiHeart(id: id) { result in
            switch result {
            case .success(_): return
            case .unAuthorized, .networkFail:
                self.showAlert?("Failed")
            default:
                return
            }
        }
    }
}
