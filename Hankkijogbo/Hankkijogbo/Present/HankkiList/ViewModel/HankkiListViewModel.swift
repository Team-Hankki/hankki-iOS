//
//  HankkiListViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation
import UIKit

import KakaoSDKCommon
import KakaoSDKShare
import KakaoSDKTemplate

final class HankkiListViewModel {
    
    weak var delegate: NetworkResultDelegate?
    
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
    
    func getZipDetail(zipId: Int) {
        NetworkService.shared.zipService.getZipDetail(zipId: zipId) { result in
            
            result.handleNetworkResult(delegate: self.delegate) { response in
                self.zipInfo = ZipHeaderTableView.Model(id: zipId,
                                                        name: UserDefaults.standard.getNickname(),
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
    
    func getSharedZipDetail(zipId: Int) {
        NetworkService.shared.zipService.getSharedZipDetail(zipId: zipId) { result in
            
            result.handleNetworkResult(delegate: self.delegate) { response in
                self.zipInfo = ZipHeaderTableView.Model(id: zipId,
                                                        name: response.data.nickname,
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
            result.handleNetworkResult(delegate: self.delegate) { response in
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
    
    // Liked List 에서 Detail로 갔을 때
    // Detail에서 Liked를 취소 하고, dismiss 한 경우
    // Liked List에 식당은 존재하되, 식당의 하트가 취소되어야함
    func updateMeHankkiList() {
        
        // 제일 최신 Liked List를 받아옴
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
                
                self.compareLikedHnakkiList(currentHankkiList)
            }
        }
    }
    
    func shareZip(handelHankkiListIsEmpty: () -> Void) {
  
        if hankkiList.isEmpty {
            handelHankkiListIsEmpty()
            return
        }
        
        let templeteID: Int64 = Int64(StringLiterals.Kakao.zipShareTemplete)
        
        let imageURL: String = hankkiList[0].imageURL.isEmpty ? StringLiterals.SharedZip.zipShareDefaultImageURL : hankkiList[0].imageURL
        
        
        let templetArgs: [String: String] = ["IMAGE_URL": imageURL,
                                             "FAVORITE_ID": String(zipInfo?.id ?? 0),
                                             "NAME": zipInfo?.title ?? "",
                                             "SENDER": zipInfo?.name ?? ""]
        
        // 카카오톡이 있는지 확인합니다.
        if ShareApi.isKakaoTalkSharingAvailable() {
            ShareApi.shared.shareCustom(templateId: templeteID, templateArgs: templetArgs) { sharingResult, error in
                if let error = error {
                    print("error : \(error)")
                } else {
                    print("sharing is success")
                    guard let sharingResult else { return }
                    UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
                }
            }
        } else {
            let url = StringLiterals.Kakao.storeUrl
            if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}

private extension HankkiListViewModel {
    func compareLikedHnakkiList(_ currentHankkiList: [HankkiListTableViewCell.Model]) {
        // 현재 Liked List에 존재하는 식당의 id와 heartCount를 dictionary 형태로 저장함
        let heartCountDict = Dictionary(uniqueKeysWithValues: currentHankkiList.map { ($0.id, $0.heartCount) })
        
        let updatedHankkiList = self.firstHankkiList.map {
            var store = $0
            if heartCountDict.keys.contains(store.id) {
                // 사용자가 Liked 를 유지한 경우
                store.isDeleted = false
                store.heartCount = heartCountDict[store.id] ?? store.heartCount
                
            } else {
                // 사용자가 Liked 를 취소한 경우
                if !store.isDeleted {
                    // Liked 취소 처리가 되지 않았을 경우
                    // -> Liked 취소 처리를 하고, 초기 heartCount 값에서 1을 감소한다.
                    store.isDeleted = true
                    store.heartCount -= 1
                }
            }
            return store
        }
        
        self.hankkiList = updatedHankkiList
    }
}
