//
//  HankkiDetailViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/18/24.
//

import Foundation

import Moya
import UIKit

final class HankkiDetailViewModel {
    
    var hankkiId: Int
    
    var setHankkiDetailData: (() -> Void)?
    var showAlert: ((String) -> Void)?
    var dismiss: (() -> Void)?
    
    var hankkiDetailData: GetHankkiDetailResponseData? {
        didSet {
            setHankkiDetailData?()
        }
    }
    weak var delegate: NetworkResultDelegate?
    
    init(hankkiId: Int) {
        self.hankkiId = hankkiId
    }
}

extension HankkiDetailViewModel {
    
    /// 식당 세부 조회
    func getHankkiDetailAPI() {
        NetworkService.shared.hankkiService.getHankkiDetail(id: hankkiId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .notFound:
                UIApplication.showBlackToast(message: StringLiterals.Toast.deleteAlready)
                self.dismiss?()
            default:
                result.handleNetworkResult(delegate: self.delegate) { response in
                    self.hankkiDetailData = response.data
                }
            }

        }
    }
    
    /// 식당 좋아요 추가
    func postHankkiHeartAPI() {
        NetworkService.shared.hankkiService.postHankkiHeart(id: hankkiId) { result in
            result.handleNetworkResult { _ in
                SetupAmplitude.shared.logEvent(AmplitudeLiterals.Detail.tabHeart)
                self.getHankkiDetailAPI()
            }
        }
    }
    
    /// 식당 좋아요 삭제
    func deleteHankkiHeartAPI() {
        NetworkService.shared.hankkiService.deleteHankkiHeart(id: hankkiId) { result in
            result.handleNetworkResult { _ in
                self.getHankkiDetailAPI()
            }
        }
    }
    
    /// 식당 삭제
    func deleteHankkiAPI(completion: @escaping () -> Void) {
        NetworkService.shared.hankkiService.deleteHankki(id: hankkiId) { result in
            result.handleNetworkResult(onSuccessVoid: completion)
        }
    }
}
