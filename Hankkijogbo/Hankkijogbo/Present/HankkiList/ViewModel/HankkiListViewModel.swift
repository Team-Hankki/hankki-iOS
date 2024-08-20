//
//  HankkiListViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation
import UIKit

final class HankkiListViewModel {
    
    var reloadCollectionView: (() -> Void)?
    var firstHankkiList: [HankkiListTableViewCell.Model] = []
    var hankkiList: [HankkiListTableViewCell.Model] = [] {
        didSet {
            self.reloadCollectionView?()
        }
    }
    var zipInfo: ZipHeaderTableView.Model?
}

extension HankkiListViewModel {
    func updateMeHankkiList() {
        let prevHankkiList: [HankkiListTableViewCell.Model] = hankkiList
        
        NetworkService.shared.userService.getMeHankkiList(.getMeHankkiHeartList) { result in
            result.handleNetworkResult { response in
                let currentHankkiList: [HankkiListTableViewCell.Model] = response.data.stores.map {
                    return HankkiListTableViewCell.Model(id: $0.id,
                                                         name: $0.name,
                                                         imageURL: $0.imageUrl ?? "",
                                                         category: $0.category,
                                                         lowestPrice: $0.lowestPrice,
                                                         heartCount: $0.heartCount)
                }
                
                // 현재 목록의 id 리스트를 Set으로 변환
                let currentIds = Set(currentHankkiList.map { $0.id })
                let heartCountDict = Dictionary(uniqueKeysWithValues: currentHankkiList.map { ($0.id, $0.heartCount) })
                
                let updatedHankkiList = self.firstHankkiList.map {
                    var store = $0
                    if !currentIds.contains(store.id) {
                        // 하트를 지웠을 경우
                        if !store.isDeleted {
                            store.isDeleted = true
                            store.heartCount -= 1
                        }
                    } else {
                        // 다시 하트를 눌렀을 경우
                        store.isDeleted = false
                        store.heartCount = heartCountDict[store.id] ?? store.heartCount
                    }
                    return store
                }
                self.hankkiList = updatedHankkiList
            }
        }
    }
    
    func getZipDetail(zipId: Int) {
        NetworkService.shared.zipService.getZipList(zipId: zipId) { result in
            
            result.handleNetworkResult { response in
                self.zipInfo = ZipHeaderTableView.Model(name: UserDefaults.standard.getNickname(),
                                                        title: response.data.title,
                                                        details: response.data.details)
                
                self.hankkiList = response.data.stores.map {
                    return HankkiListTableViewCell.Model(id: $0.id,
                                                         name: $0.name,
                                                         imageURL: $0.imageUrl ?? "",
                                                         category: $0.category,
                                                         lowestPrice: $0.lowestPrice,
                                                         heartCount: $0.heartCount)
                }
            }
        }
    }
    
    func getMeHankkiList(_ type: UserTargetType) {
        NetworkService.shared.userService.getMeHankkiList(type) { result in
            result.handleNetworkResult { response in
                self.hankkiList = response.data.stores.map {
                    return HankkiListTableViewCell.Model(id: $0.id,
                                                         name: $0.name,
                                                         imageURL: $0.imageUrl ?? "",
                                                         category: $0.category,
                                                         lowestPrice: $0.lowestPrice,
                                                         heartCount: $0.heartCount)
                }
                
                self.firstHankkiList = self.hankkiList
            }
        }
    }
    
    func deleteZipToHankki(requestBody: DeleteZipToHankkiRequestDTO, completion: @escaping () -> Void) {
        NetworkService.shared.zipService.deleteZipToHankki(requestBody: requestBody) { result in
            result.handleNetworkResult(onSuccessVoid: completion)
        }
    }
    
    func postHankkiHeart(id: Int) {
        NetworkService.shared.hankkiService.postHankkiHeart(id: id) { result in
            result.handleNetworkResult()
        }
    }
    
    func deleteHankkiHeart(id: Int) {
        NetworkService.shared.hankkiService.deleteHankkiHeart(id: id) { result in
            result.handleNetworkResult()
        }
    }
}
