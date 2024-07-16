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
//    func getPriceCategoryFilter(completion: @escaping(NetworkResult<GetPriceCategoryFilterResponseDTO>) -> Void)
//    func getSortOptionFilter(completion: @escaping(NetworkResult<GetSortOptionResponseDTO>) -> Void)
//    func getHankkiPin(completion: @escaping(NetworkResult<GetHankkiPinResponseDTO>) -> Void)
}

final class HankkiAPIService: BaseAPIService, HankkiAPIServiceProtocol {
    
    private let provider = MoyaProvider<HankkiTargetType>(plugins: [MoyaPlugin()])
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
}
