//
//  HakkiAPIService.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation
import Moya

protocol HankkiAPIServiceProtocol {
    func getCategoryFilter(completion: @escaping(NetworkResult<BaseDTO<GetCategoryFilterResponseData>>) -> Void)
    func getPriceCategoryFilter(completion: @escaping(NetworkResult<BaseDTO<GetPriceFilterResponseData>>) -> Void)
    func getSortOptionFilter(completion: @escaping(NetworkResult<BaseDTO<GetSortOptionFilterResponseData>>) -> Void)
    func getHankkiList(completion: @escaping(NetworkResult<BaseDTO<GetHankkiListResponseData>>) -> Void)
}

final class HankkiAPIService: BaseAPIService, HankkiAPIServiceProtocol {
    
    private let provider = MoyaProvider<HankkiTargetType>(plugins: [MoyaPlugin()])
    
    /// 카테고리 필터 드롭다운 정보 조회
    func getCategoryFilter(completion: @escaping (NetworkResult<BaseDTO<GetCategoryFilterResponseData>>) -> Void) {
        provider.request(.getCategoryFilter) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<GetCategoryFilterResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<GetCategoryFilterResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 가격 필터 드롭다운 정보 조회
    func getPriceCategoryFilter(completion: @escaping (NetworkResult<BaseDTO<GetPriceFilterResponseData>>) -> Void) {
        provider.request(.getPriceCategoryFilter) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<GetPriceFilterResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<GetPriceFilterResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 정렬 드롭다운 정보 조회
    func getSortOptionFilter(completion: @escaping (NetworkResult<BaseDTO<GetSortOptionFilterResponseData>>) -> Void) {
        provider.request(.getSortOptionFilter) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<GetSortOptionFilterResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<GetSortOptionFilterResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 메인 페이지 식당 리스트 조회
    func getHankkiList(completion: @escaping (NetworkResult<BaseDTO<GetHankkiListResponseData>>) -> Void) {
        provider.request(.getSortOptionFilter) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<GetHankkiListResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<GetHankkiListResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
}
