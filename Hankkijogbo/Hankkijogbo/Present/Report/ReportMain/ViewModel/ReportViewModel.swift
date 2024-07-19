//
//  ReportViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/17/24.
//

import Foundation

import Moya
import UIKit

final class ReportViewModel {
    var showAlert: ((String) -> Void)?
    
    var nickname: String?
    
    var count: Int = 0 {
        didSet {
            updateCollectionView?()
        }
    }
    
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
    var selectedCategory: GetCategoryFilterData?
    
    var selectedImageData: Data?
    
    var menus: [MenuData] = [MenuData()]
}

extension ReportViewModel {
    
    func getReportedNumberAPI() {
        NetworkService.shared.reportService.getReportedNumber { [weak self] result in
            switch result {
            case .success(let response):
                guard let count = response?.data.count else { return }
                self?.count = Int(count)
                self?.reportedNumberGuideText = "\(count)번째 제보예요"
            case .badRequest, .unAuthorized, .serverError:
                self?.showAlert?("Failed to fetch category filters.")
            default:
                return
            }
        }
    }
    
    func getMe(completion: @escaping(String) -> Void) {
        NetworkService.shared.userService.getMe { result in
            switch result {
            case .success(let response):
                self.nickname = response?.data.nickname
                completion(self.nickname ?? "")
            default:
                return
            }
        }
    }
    
    /// 식당 제보하기
    func postHankkiAPI(request: PostHankkiRequestDTO, completion: @escaping (PostHankkiResponseData) -> Void) {
        let multipartData = createMultipartFormData(image: selectedImageData, request: request)
        NetworkService.shared.hankkiService.postHankki(multipartData: multipartData) { result in
            switch result {
            case .success(let response):
                guard let data = response?.data else { return }
                print(data)
                self.getMe() { name in
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootViewController = windowScene.windows.first?.rootViewController as? UINavigationController {
                        let reportCompleteViewController = ReportCompleteViewController(hankkiId: Int(response?.data.id ?? 0),
                                                                                        reportedNumber: self.count,
                                                                                        nickname: name,
                                                                                        selectedHankkiName: response?.data.name ?? "")
                        rootViewController.pushViewController(reportCompleteViewController, animated: true)
                    }
                }
            case .badRequest, .unAuthorized, .serverError:
                self.showAlert?("Failed to fetch category filters.")
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
                self?.showAlert?("Failed to fetch category filters.")
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
        let jsonData = convertToJSON(request: request)
        multipartData.append(MultipartFormData(provider: .data(jsonData), name: "request", fileName: "request.json", mimeType: "application/json"))
        return multipartData
    }

    func convertToJSON(request: PostHankkiRequestDTO) -> Data {
        do {
            let jsonData = try JSONEncoder().encode(request)
            return jsonData
        } catch {
            print("JSON 변환 실패", error.localizedDescription)
        }
        return Data()
    }
}
