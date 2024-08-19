//
//  HankkiListViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation
import UIKit

final class HankkiListViewModel {
    
    init() {
        getMe()
    }
    
    var name: String?
    var imageUrl: String?

    var reloadCollectionView: (() -> Void)?
    
    var hankkiList: [HankkiListTableViewCell.Model] = [] {
        didSet {
            self.reloadCollectionView?()
        }
    }
    var zipInfo: ZipHeaderTableView.Model?
}

extension HankkiListViewModel {
    func getMe() {
        NetworkService.shared.userService.getMe { result in
            result.handleNetworkResult { response in
                self.name = response.data.nickname
                self.imageUrl = response.data.profileImageUrl
            }
        }
    }
    
    func getZipDetail(zipId: Int) {
        NetworkService.shared.zipService.getZipList(zipId: zipId) { result in
            
            result.handleNetworkResult { response in
                self.zipInfo = ZipHeaderTableView.Model(name: self.name ?? "",
                                                             imageUrl: self.imageUrl ?? "",
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
