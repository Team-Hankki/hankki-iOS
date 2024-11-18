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
    
    var setHankkiDetailData: (() -> Void)?
    var showAlert: ((String) -> Void)?
    var dismiss: (() -> Void)?
    
    var hankkiDetailData: GetHankkiDetailResponseData? {
        didSet {
            setHankkiDetailData?()
        }
    }
    
    /// 식당 세부 조회
    func getHankkiDetailAPI(hankkiId: Int) {
        NetworkService.shared.hankkiService.getHankkiDetail(id: hankkiId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .notFound:
                UIApplication.showBlackToast(message: StringLiterals.Toast.deleteAlready)
                self.dismiss?()
            default:
                result.handleNetworkResult { response in
                    self.hankkiDetailData = response.data
                }
            }

        }
    }
    
    /// 식당 좋아요 추가
    func postHankkiHeartAPI(id: Int, completion: @escaping () -> Void) {
        NetworkService.shared.hankkiService.postHankkiHeart(id: id) { result in
            result.handleNetworkResult { _ in
                SetupAmplitude.shared.logEvent(AmplitudeLiterals.Detail.tabHeart)
                completion()
            }
        }
    }
    
    /// 식당 좋아요 삭제
    func deleteHankkiHeartAPI(id: Int, completion: @escaping () -> Void) {
        NetworkService.shared.hankkiService.deleteHankkiHeart(id: id) { result in
            result.handleNetworkResult { _ in completion() }
        }
    }
    
    /// 식당 삭제
    func deleteHankkiAPI(id: Int, completion: @escaping () -> Void) {
        NetworkService.shared.hankkiService.deleteHankki(id: id) { result in
            result.handleNetworkResult(onSuccessVoid: completion)
        }
    }
}
