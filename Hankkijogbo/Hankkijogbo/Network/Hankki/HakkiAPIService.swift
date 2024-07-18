//
//  HakkiAPIService.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation
import Moya

protocol HankkiAPIServiceProtocol {
    func getCategoryFilter(completion: @escaping(NetworkResult<GetCategoryFilterResponseDTO>) -> Void)
    func getPriceCategoryFilter(completion: @escaping(NetworkResult<GetPriceFilterResponseDTO>) -> Void)
    func getSortOptionFilter(completion: @escaping(NetworkResult<GetSortOptionFilterResponseDTO>) -> Void)
    func postHankkiValidate(req: PostHankkiValidateRequestDTO, completion: @escaping(NetworkResult<EmptyDTO>) -> Void)
}

final class HankkiAPIService: BaseAPIService, HankkiAPIServiceProtocol {
    
    private let provider = MoyaProvider<HankkiTargetType>(plugins: [MoyaPlugin()])
    
    /// 카테고리 필터 드롭다운 정보 조회
    func getCategoryFilter(completion: @escaping (NetworkResult<GetCategoryFilterResponseDTO>) -> Void) {
        provider.request(.getCategoryFilter) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetCategoryFilterResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetCategoryFilterResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 가격 필터 드롭다운 정보 조회
    func getPriceCategoryFilter(completion: @escaping (NetworkResult<GetPriceFilterResponseDTO>) -> Void) {
        provider.request(.getPriceCategoryFilter) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetPriceFilterResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetPriceFilterResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 정렬 드롭다운 정보 조회
    func getSortOptionFilter(completion: @escaping (NetworkResult<GetSortOptionFilterResponseDTO>) -> Void) {
        provider.request(.getSortOptionFilter) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetSortOptionFilterResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetSortOptionFilterResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 이미 등록된 식당인지 판별
    func postHankkiValidate(req: PostHankkiValidateRequestDTO, completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
        provider.request(.postHankkiValidate(req: req)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<EmptyDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}
