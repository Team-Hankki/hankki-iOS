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
    
    var myZipListFavoriteData: [GetMyZipFavorite]? {
        didSet {
            setMyZipListFavoriteData?()
        }
    }
    var setMyZipListFavoriteData: (() -> Void)?
    
    /// 내 식당 족보 리스트 조회
    func getMyZipListAPI(id: Double) {
        NetworkService.shared.zipService.getMyZipList(id: id) { [weak self] result in
            switch result {
            case .success(let response):
                guard let response = response else { return }
                self?.myZipListFavoriteData = response.data.favorites
                print("SUCCESS")
            case .unAuthorized, .networkFail:
                self?.showAlert?("Failed")
                print("FAILED")
            default:
                return
            }
        }
    }
    
    /// 족보에 식당 추가
    func postHankkiToZipAPI(request: PostHankkiToZipRequestDTO) {
        NetworkService.shared.zipService.postHankkiToZip(requestBody: request) { result in
            switch result {
            case .success(let response):
                print("SUCCESS")
            case .unAuthorized, .networkFail:
                self.showAlert?("Failed")
                print("FAILED")
            default:
                return
            }
        }
    }
}
