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
    
    // 필터링 데이터를 저장할 프로퍼티
    var categoryFilters: [GetCategoryFilterData] = []
    var priceFilters: [GetPriceFilterData] = []
    var sortOptions: [GetSortOptionFilterData] = []
    var hankkiLists: [GetHankkiListData] = []
    
    init(hankkiAPIService: HankkiAPIServiceProtocol = HankkiAPIService()) {
        self.hankkiAPIService = hankkiAPIService
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
    
    //    // 식당 리스트를 가져오는 메서드
    //    func getHankkiListAPI(completion: @escaping (Bool) -> Void) {
    //        NetworkService.shared.hankkiService.getHankkiList { [weak self] result in
    //            switch result {
    //            case .success(let response):
    //                self?.hankkiLists = response?.data.stores ?? []
    //                completion(true)
    //                print("SUCESS")
    //            case .unAuthorized, .networkFail:
    //                completion(false)
    //                print("FAILED")
    //            default:
    //                return
    //            }
    //        }
    //    }
    // 식당 리스트를 가져오는 메서드
    func getHankkiListAPI(university: String, category: String, lowestPrice: String, order: String, completion: @escaping (Bool) -> Void) {
        NetworkService.shared.hankkiService.getHankkiList(university: university, category: category, lowestPrice: lowestPrice, order: order) { [weak self] result in
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

