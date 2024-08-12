//
//  ReportViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/17/24.
//

import Foundation

import Moya
import UIKit // todo: 제거

final class ReportViewModel {
    var showAlert: ((String) -> Void)?
    var updateCollectionView: ((Int) -> Void)?
    var updateButton: ((Bool) -> Void)?
    
    var nickname: String?
    var reportedNumber: Int = 0
    var reportedNumberGuideText: String = ""
    var selectedLocationData: GetSearchedLocation? {
        didSet {
            checkStatus()
        }
    }
    var categories: [HankkiCategoryModel] = [] {
        didSet {
            updateSelectedCategory()
            updateCollectionView?(ReportSectionType.category.rawValue)
        }
    }
    var selectedCategory: HankkiCategoryModel? {
        didSet {
            checkStatus()
        }
    }
    var selectedImageData: Data?
    var menus: [MenuData] = [MenuData()] {
        didSet {
            checkStatus()
        }
    }
    var validMenus: [MenuData] = []
    var isValid: Bool? {
        didSet {
            updateButton?(isValid ?? false)
        }
    }
}

private extension ReportViewModel {
    
    func updateSelectedCategory() {
        if let selectedCategory = categories.first(where: { $0.isChecked }) {
            self.selectedCategory = selectedCategory
        } else {
            selectedCategory = nil
        }
    }
    
    func checkStatus() {
        if selectedLocationData != nil {
            if selectedCategory != nil {
                isValid = menus.allSatisfy { menu in
                    !menu.name.isEmpty && menu.price > 0 && menu.price <= 8000
                }
            } else {
                isValid = false
            }
        } else {
            isValid = false
        }
    }
}

extension ReportViewModel {
    
    /// isChecked가 true인 것만 false로 변경
    func disableCheckedCategories() {
        categories.enumerated().forEach { index, category in
            if category.isChecked {
                categories[index].isChecked = false
            }
        }
    }
    
    func getReportedNumberAPI() {
        NetworkService.shared.reportService.getReportedNumber { result in
            result.handleNetworkResult { [weak self] response in
                let reportedNumber = response.data.count
                self?.reportedNumber = Int(reportedNumber)
                self?.reportedNumberGuideText = "\(reportedNumber)\(StringLiterals.Report.numberOfReport)"
                self?.updateCollectionView?(ReportSectionType.search.rawValue)
            }
        }
    }
    
    func getMe(completion: @escaping(String) -> Void) {
        NetworkService.shared.userService.getMe { result in
            result.handleNetworkResult { [weak self] response in
                self?.nickname = response.data.nickname
                completion(self?.nickname ?? "")
            }
        }
    }
    
    /// 데이터 필터링 후 req 만들어서 식당 제보하기
    /// - 유저가 실제 작성한 데이터(menus)와 실제 API 요청으로 보내는 데이터(validMenus)를 다른 변수로 관리해서 필터링
    func postHankkiAPI(locationData: GetSearchedLocation) {
        validMenus = menus.filter { $0.name != "" && $0.price > 0 && $0.price <= 8000 }

        let request: PostHankkiRequestDTO = PostHankkiRequestDTO(
            name: locationData.name,
            category: selectedCategory?.categoryData.tag ?? "",
            address: locationData.address ?? "",
            latitude: locationData.latitude,
            longitude: locationData.longitude,
            universityId: UserDefaults.standard.getUniversity()?.id ?? 0,
            menus: validMenus
        )
        
        let multipartData = createMultipartFormData(image: selectedImageData, request: request)
        NetworkService.shared.hankkiService.postHankki(multipartData: multipartData) { result in
            result.handleNetworkResult { [weak self] response in
                guard let self = self else { return }
                let data = response.data
                self.getMe { name in
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootViewController = windowScene.windows.first?.rootViewController as? UINavigationController {
                        let reportCompleteViewController = ReportCompleteViewController(hankkiId: data.id,
                                                                                        reportedNumber: self.reportedNumber,
                                                                                        nickname: name,
                                                                                        selectedHankkiName: data.name)
                        rootViewController.pushViewController(reportCompleteViewController, animated: true)
                    }
                }
            }
        }
    }
    
    // 종류 카테고리를 가져오는 메서드
    func getCategoryFilterAPI() {
        NetworkService.shared.hankkiService.getCategoryFilter { result in
            result.handleNetworkResult { [weak self] response in
                self?.categories = response.data.categories.map {
                    HankkiCategoryModel(categoryData: $0, isChecked: false)
                }
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
