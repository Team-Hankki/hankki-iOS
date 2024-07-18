//
//  HankkiDetailViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/18/24.
//

import Foundation

import Moya

final class HankkiDetailViewModel {
    
    var hankkiDetailData: GetHankkiDetailResponseData? {
        didSet {
            setHankkiDetailData?()
        }
    }
    var setHankkiDetailData: (() -> Void)?
    
    /// 식당 세부 조회
    func getHankkiDetailAPI() {
        NetworkService.shared.hankkiService.getHankkiDetail(id: 19) { [weak self] result in
            switch result {
            case .success(let response):
                guard let response = response else { return }
                self?.hankkiDetailData = response.data
                print("SUCCESS")
            case .unAuthorized, .networkFail:
                print("FAILED")
            default:
                return
            }
        }
    }
    
    /// 식당 좋아요 추가
    func postHankkiHeartAPI(id: Int64, completion: @escaping () -> Void) {
        NetworkService.shared.hankkiService.postHankkiHeart(id: id) { [weak self] result in
            switch result {
            case .success(let response):
                guard let response = response else { return }
                print("SUCCESS")
                completion()
            case .unAuthorized, .networkFail:
                print("FAILED")
            default:
                return
            }
        }
    }
    
    /// 식당 좋아요 삭제
    func deleteHankkiHeartAPI(id: Int64, completion: @escaping () -> Void) {
        NetworkService.shared.hankkiService.deleteHankkiHeart(id: id) { [weak self] result in
            switch result {
            case .success(let response):
                guard let response = response else { return }
                print("SUCCESS")
                completion()
            case .unAuthorized, .networkFail:
                print("FAILED")
            default:
                return
            }
        }
    }
}
