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
    
}
