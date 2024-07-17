//
//  HomeViewModel.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import Foundation

import Moya

final class HomeViewModel {
    private let hankkiAPIService: HankkiAPIServiceProtocol
    
    var categoryFilters: [GetCategoryFilterData] = []
    var priceFilters: [GetPriceFilterData] = []
    var sortOptions: [GetSortOptionFilterData] = []
    var hankkiLists: [GetHankkiListData] = [] {
        didSet {
            hankkiListsDidChange?(hankkiLists)
        }
    }
    
    var hankkiListsDidChange: (([GetHankkiListData]) -> Void)?
    
    private let universityid: Int = 1
    
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

    private func updateHankkiList() {
        let storeCategory = storeCategory ?? ""
        let priceCategory = priceCategory ?? ""
        let sortOption = sortOption ?? ""
        
        getHankkiListAPI(universityid: universityid, storeCategory: storeCategory, priceCategory: priceCategory, sortOption: sortOption) { success in
            if success {
                print("Hankki list fetched successfully")
            } else {
                print("Failed to fetch hankki list")
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
    
    // 가격 카테고리를 가져오는 메서드
    func getPriceCategoryFilterAPI(completion: @escaping (Bool) -> Void) {
        NetworkService.shared.hankkiService.getPriceCategoryFilter { [weak self] result in
            switch result {
            case .success(let response):
                self?.priceFilters = response?.data.priceCategories ?? []
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
    
    // 정렬 옵션을 가져오는 메서드
    func getSortOptionFilterAPI(completion: @escaping (Bool) -> Void) {
        NetworkService.shared.hankkiService.getSortOptionFilter { [weak self] result in
            switch result {
            case .success(let response):
                self?.sortOptions = response?.data.options ?? []
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
    
    
    // 식당 리스트를 가져오는 메서드
    func getHankkiListAPI(universityid: Int, storeCategory: String, priceCategory: String, sortOption: String, completion: @escaping (Bool) -> Void) {
        NetworkService.shared.hankkiService.getHankkiList(universityid: universityid, storeCategory: storeCategory, priceCategory: priceCategory, sortOption: sortOption) { [weak self] result in
            switch result {
            case .success(let response):
                self?.hankkiLists = response?.data.stores ?? []
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
