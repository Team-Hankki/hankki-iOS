//
//  ReportViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/17/24.
//

import Foundation

import Moya

final class ReportViewModel {
    private let reportAPIService: ReportAPIServiceProtocol

    var reportedNumberGuideText: String = "" {
        didSet {
            updateReportedNumber?()
        }
    }
    var updateReportedNumber: (() -> Void)?
    
    init(reportAPIService: ReportAPIServiceProtocol = ReportAPIService()) {
        self.reportAPIService = reportAPIService
    }

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
    
    func postHankkiAPI(_ data: Data?) {
        let multipartData = createMultipartFormData(data)
        NetworkService.shared.hankkiService.postHankki(multipartData: multipartData) { [weak self] result in
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
    
    private func createMultipartFormData(_ image: Data?) -> [MultipartFormData] {
        var multipartData: [MultipartFormData] = []
        multipartData.append(MultipartFormData(provider: .data(image ?? .empty), name: "image", fileName: "image.jpg", mimeType: "image/jpeg"))
        let jsonData = changeJSONData()
        multipartData.append(MultipartFormData(provider: .data(jsonData), name: "request", fileName: "request.json", mimeType: "application/json"))
        return multipartData
    }

    private func changeJSONData() -> Data {
        let requestData = """
            {
                "name": "식당이름",
                "category": "KOREAN",
                "address": "문래동",
                "latitude": 1111811381504.1,
                "longitude": 1,
                "universityId": 2,
                "menus": [
                    {
                        "name": "떡볶이",
                        "price": 6000
                    },
                    {
                        "name": "순대",
                        "price": 8000
                    }
                ]
            }
            """
        return requestData.data(using: .utf8)!
    }

}
