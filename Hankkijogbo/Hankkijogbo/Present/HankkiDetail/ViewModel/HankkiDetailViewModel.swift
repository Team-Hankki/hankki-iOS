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
    var hankkiDetailData: GetHankkiDetailResponseData? {
        didSet {
            setHankkiDetailData?()
        }
    }
    var address: String? {
        didSet {
            setHankkiDetailData?()
        }
    }
    var removeOptions: [String] = [
        StringLiterals.RemoveHankki.optionDisappeared,
        StringLiterals.RemoveHankki.optionNoMore8000,
        StringLiterals.RemoveHankki.optionImproperHankki
    ]
    
    weak var delegate: NetworkResultDelegate?
    
    var setHankkiDetailData: (() -> Void)?
    var showAlert: ((String) -> Void)?
    var dismiss: (() -> Void)?
    
    init(hankkiId: Int) {
        self.hankkiId = hankkiId
    }
}

extension HankkiDetailViewModel {
    
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
                    self.getHankkiAddressAPI() // 상세 조회 후 주소도 같이 불러옴
                }
            }
        }
    }
    
    func postHankkiHeartAPI() {
        NetworkService.shared.hankkiService.postHankkiHeart(id: hankkiId) { result in
            result.handleNetworkResult { _ in
                SetupAmplitude.shared.logEvent(AmplitudeLiterals.Detail.tabHeart)
                self.getHankkiDetailAPI()
            }
        }
    }
    
    func deleteHankkiHeartAPI() {
        NetworkService.shared.hankkiService.deleteHankkiHeart(id: hankkiId) { result in
            result.handleNetworkResult { _ in
                self.getHankkiDetailAPI()
            }
        }
    }
    
    func deleteHankkiAPI(completion: @escaping () -> Void) {
        NetworkService.shared.hankkiService.deleteHankki(id: hankkiId) { result in
            result.handleNetworkResult(onSuccessVoid: completion)
        }
    }
}

private extension HankkiDetailViewModel {
    
    func getHankkiAddressAPI() {
        guard let detailData = hankkiDetailData else { return }
        NetworkService.shared.naverMapService.getHankkiAddress(latitude: detailData.latitude, longitude: detailData.longitude) { result in
            switch result {
            case .badRequest:
                UIApplication.showBlackToast(message: StringLiterals.Toast.serverError)
            case .serverError:
                UIApplication.showBlackToast(message: StringLiterals.Toast.serverError)
            default:
                result.handleNetworkResult { response in
                    guard let data = response.results.first,
                          let data = data else {
                        self.address = "-"
                        return
                    }

                    self.address = self.formatAddress(from: data)
                }
            }
        }
    }
    
    func formatAddress(from data: GetHankkiAddressResult) -> String {
        let address: [String?] = [
            data.region?.area1?.name,
            data.region?.area2?.name,
            data.region?.area3?.name,
            data.region?.area4?.name,
            data.land?.name,
            data.land?.number1,
            data.land?.number2
        ]
        
        return address
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}
