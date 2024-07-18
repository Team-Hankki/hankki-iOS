//
//  ReportViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/17/24.
//

import Foundation

import Moya

final class ReportViewModel {
    
    var reportedNumberGuideText: String = "" {
        didSet {
            updateCollectionView?()
        }
    }
    var updateCollectionView: (() -> Void)?
    
    var categoryFilters: [GetCategoryFilterData] = [] {
        didSet {
            updateCollectionView?()
        }
    }
}

extension ReportViewModel {
    
    func getReportedNumberAPI() {
        NetworkService.shared.reportService.getReportedNumber { [weak self] result in
            switch result {
            case .success(let response):
                guard let count = response?.data.count else { return }
                self?.reportedNumberGuideText = "\(count)번째 제보예요"
            case .badRequest, .unAuthorized:
                // TODO: - 에러 상황에 공통적으로 띄워줄만한 Alert나 Toast가 있어야 하지 않을까?
                print("badRequest")
            case .serverError:
                print("serverError")
            default:
                return
            }
        }
    }
    
    /// 식당 제보하기
    func postHankkiAPI(_ data: Data?, request: PostHankkiRequestDTO) {
        let multipartData = createMultipartFormData(image: data, request: request)
        NetworkService.shared.hankkiService.postHankki(multipartData: multipartData) { result in
            switch result {
            case .success(let response):
                guard let data = response?.data else { return }
                print(data)
            case .badRequest, .unAuthorized:
                // TODO: - 에러 상황에 공통적으로 띄워줄만한 Alert나 Toast가 있어야 하지 않을까?
                print("badRequest")
            case .serverError:
                print("serverError")
            default:
                return
            }
        }
    }
    
    // 종류 카테고리를 가져오는 메서드
    func getCategoryFilterAPI(completion: @escaping (Bool) -> Void) {
        NetworkService.shared.hankkiService.getCategoryFilter { [weak self] result in
            switch result {
            case .success(let response):
                self?.categoryFilters = response?.data.categories ?? []
                completion(true)
                print("SUCCESS")
            case .unAuthorized, .networkFail:
                completion(false)
                print("FAILED")
            default:
                return
            }
        }
    }
}

private extension ReportViewModel {
    
    func createMultipartFormData(image: Data?, request: PostHankkiRequestDTO) -> [MultipartFormData] {
        var multipartData: [MultipartFormData] = []
        multipartData.append(MultipartFormData(provider: .data(image ?? .empty), name: "image", fileName: "image.jpg", mimeType: "image/jpeg"))
        let jsonData = changeJSONData(request: request)
        multipartData.append(MultipartFormData(provider: .data(jsonData), name: "request", fileName: "request.json", mimeType: "application/json"))
        return multipartData
    }

    func changeJSONData(request: PostHankkiRequestDTO) -> Data {
        let requestData = """
            \(request)
            """
        return requestData.data(using: .utf8)!
    }
}
