//
//  HankkiDetailViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/18/24.
//

import Foundation

import Moya

final class HankkiDetailViewModel {
    var showAlert: ((String) -> Void)?
    
    var hankkiDetailData: GetHankkiDetailResponseData? {
        didSet {
            setHankkiDetailData?()
        }
    }
    var setHankkiDetailData: (() -> Void)?
    
    /// 식당 세부 조회
    func getHankkiDetailAPI(hankkiId: Int) {
        NetworkService.shared.hankkiService.getHankkiDetail(id: hankkiId) { [weak self] result in
            switch result {
            case .success(let response):
                guard let response = response else { return }
                self?.hankkiDetailData = response.data
                print("SUCCESS")
            case .unAuthorized, .networkFail:
                self?.showAlert?("Failed to fetch category filters.")
                print("FAILED")
            default:
                return
            }
        }
    }
    
    /// 식당 좋아요 추가
    func postHankkiHeartAPI(id: Int, completion: @escaping () -> Void) {
        NetworkService.shared.hankkiService.postHankkiHeart(id: id) { [weak self] result in
            switch result {
            case .success(let response):
                guard let response = response else { return }
                print("SUCCESS")
                completion()
            case .unAuthorized, .networkFail:
                self?.showAlert?("Failed to fetch category filters.")
                print("FAILED")
            default:
                return
            }
        }
    }
    
    /// 식당 좋아요 삭제
    func deleteHankkiHeartAPI(id: Int, completion: @escaping () -> Void) {
        NetworkService.shared.hankkiService.deleteHankkiHeart(id: id) { [weak self] result in
            switch result {
            case .success(let response):
                guard let response = response else { return }
                print("SUCCESS")
                completion()
            case .unAuthorized, .networkFail:
                self?.showAlert?("Failed to fetch category filters.")
                print("FAILED")
            default:
                return
            }
        }
    }
}
