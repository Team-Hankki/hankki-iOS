//
//  MyZipViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/19/24.
//

import Foundation

import Moya

final class MyZipViewModel {
    
    var showAlert: ((String) -> Void)?
    var showAddToZipCompleteToast: (() -> Void)?
    
    var myZipListFavoriteData: [GetMyZipFavorite]? {
        didSet {
            setMyZipListFavoriteData?()
        }
    }
    var setMyZipListFavoriteData: (() -> Void)?
    
    /// 내 식당 족보 리스트 조회
    func getMyZipListAPI(id: Int) {
        NetworkService.shared.zipService.getMyZipList(id: id) { result in
            result.handleNetworkResult { [weak self] response in
                self?.myZipListFavoriteData = response.data.favorites
            }
        }
    }
    
    /// 족보에 식당 추가
    func postHankkiToZipAPI(request: PostHankkiToZipRequestDTO, completion: @escaping (() -> Void)) {
        NetworkService.shared.zipService.postHankkiToZip(requestBody: request) { result in
            result.handleNetworkResult { [weak self] _ in
                self?.showAddToZipCompleteToast?()
                SetupAmplitude.shared.logEvent(AmplitudeLiterals.MyZipListBottomSheet.tabAdd)
                completion()
            }
        }
    }
}
