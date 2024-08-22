//
//  HomeViewModel.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import Foundation

import Moya
import UIKit

final class HomeViewModel {
    
    private let hankkiAPIService: HankkiAPIServiceProtocol
    var showAlert: ((String) -> Void)?
    
    var categoryFilters: [GetCategoryFilterData] = []
    var priceFilters: [GetPriceFilterData] = []
    var sortOptions: [GetSortOptionFilterData] = [] {
        didSet {
            print(sortOptions)
        }
    }
    
    var hankkiLists: [GetHankkiListData] = [] {
        didSet {
            hankkiListsDidChange?(hankkiLists)
        }
    }
    
    var hankkiPins: [GetHankkiPinData] = [] {
        didSet {
            hankkiPinsDidChange?(hankkiPins)
        }
    }
    
    var hankkiThumbnail: GetHankkiThumbnailResponseData?
    
    var hankkiListsDidChange: (([GetHankkiListData]) -> Void)?
    var hankkiPinsDidChange: (([GetHankkiPinData]) -> Void)?
    var onHankkiListFetchCompletion: ((Bool, Bool) -> Void)?
    
    var storeCategory: String? {
        didSet { updateHankkiList() }
    }
    var priceCategory: String? {
        didSet { updateHankkiList() }
    }
    var sortOption: String? {
        didSet { updateHankkiList() }
    }
    
    init(hankkiAPIService: HankkiAPIServiceProtocol = HankkiAPIService()) {
        self.hankkiAPIService = hankkiAPIService
    }
}

extension HomeViewModel {
    func updateHankkiList() {
        let storeCategory = storeCategory ?? ""
        let priceCategory = priceCategory ?? ""
        let sortOption = sortOption ?? ""
        
        guard let id = UserDefaults.standard.getUniversity()?.id else { return }
        
        self.getHankkiListAPI(universityId: id, storeCategory: storeCategory, priceCategory: priceCategory, sortOption: sortOption) { success in
            if success {
                print("식당 전체 족보 fetch 완료 😄")
                self.hankkiListsDidChange?(self.hankkiLists)
                self.getHankkiPinAPI(universityId: id, storeCategory: storeCategory, priceCategory: priceCategory, sortOption: sortOption) { pinSuccess in
                    if pinSuccess {
                        print("지도 핀 fetch 완료 😄")
                        self.hankkiPinsDidChange?(self.hankkiPins)
                    } else {
                        print("지도 핀 fetch 실패 😞")
                    }
                }
            } else {
                print("식당 족보 fetch 실패 😞")
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
                self?.showAlert?("Failed")
                completion(false)
                print("FAILED")
            default:
                return
            }
        }
    }
    
    // 가격 카테고리를 가져오는 메서드
    func getPriceCategoryFilterAPI(completion: @escaping (Bool) -> Void) {
        NetworkService.shared.hankkiService.getPriceCategoryFilter { [weak self] result in
            switch result {
            case .success(let response):
                self?.priceFilters = response?.data.priceCategories ?? []
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
    
    // 정렬 옵션을 가져오는 메서드
    func getSortOptionFilterAPI(completion: @escaping (Bool) -> Void) {
        NetworkService.shared.hankkiService.getSortOptionFilter { [weak self] result in
            switch result {
            case .success(let response):
                self?.sortOptions = response?.data.options ?? []
                completion(true)
                print("SUCCESS")
            case .unAuthorized, .networkFail:
                self?.showAlert?("Failed")
                completion(false)
                print("FAILED")
            default:
                return
            }
        }
    }
    
  //   식당 리스트를 가져오는 메서드
    func getHankkiListAPI(universityId: Int? = nil, storeCategory: String, priceCategory: String, sortOption: String, completion: @escaping (Bool) -> Void) {
        NetworkService.shared.hankkiService.getHankkiList(universityId: universityId, storeCategory: storeCategory, priceCategory: priceCategory, sortOption: sortOption) { [weak self] result in
            switch result {
            case .success(let response):
                self?.hankkiLists = response?.data.stores.map { store in
                    var modifiedStore = store
                    modifiedStore.imageUrl = store.imageUrl ?? "img_detail_default"
                    return modifiedStore
                } ?? []
                self?.hankkiListsDidChange?(self?.hankkiLists ?? [])
                completion(true)
                self?.onHankkiListFetchCompletion?(true, self?.hankkiLists.isEmpty ?? true)
                print("SUCCESS")
            case .unAuthorized, .networkFail:
                self?.showAlert?("Failed")
                completion(false)
                self?.onHankkiListFetchCompletion?(false, true)
                print("FAILED")
            default:
                return
            }
        }
    }

    // 식당 핀을 가져오는 메서드
    func getHankkiPinAPI(universityId: Int? = nil, storeCategory: String, priceCategory: String, sortOption: String, completion: @escaping (Bool) -> Void) {
        NetworkService.shared.hankkiService.getHankkiPin(universityId: universityId, storeCategory: storeCategory, priceCategory: priceCategory, sortOption: sortOption) { [weak self] result in
            switch result {
            case .success(let response):
                self?.hankkiPins = response?.data.pins ?? []
                self?.hankkiPinsDidChange?(self?.hankkiPins ?? [])
                completion(true)
                print("SUCCESS")
            case .unAuthorized, .networkFail:
                self?.showAlert?("Failed")
                completion(false)
                print("FAILED")
            default:
                return
            }
        }
    }
    
    // 식당 썸네일을 가져오는 메서드
    func getThumbnailAPI(id: Int, completion: @escaping (Bool) -> Void) {
        NetworkService.shared.hankkiService.getHankkiThumbnail(id: id) { result in
            switch result {
            case .success(let response):
                if let thumbnailData = response?.data {
                    self.hankkiThumbnail = thumbnailData
                    completion(true)
                } else { return }
            case .unAuthorized, .networkFail:
                self.showAlert?("Failed")
                completion(false)
            default:
                return
            }
        }
    }
    
    func getMeUniversity() {
        NetworkService.shared.userService.getMeUniversity { result in
            switch result {
            case .success(let response):
                print("SUCCESS")
            case .unAuthorized, .networkFail:
                self.showAlert?("Failed")
                print("FAILED")
            default:
                return
            }
        }
    }
}
