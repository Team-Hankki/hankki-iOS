//
//  UniversityService.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

import Moya

protocol UniversityAPIServiceProtocol {
    func getUniversityList(completion: @escaping(NetworkResult<BaseDTO<GetUniversityListResponseDataDTO>>) -> Void)
}

final class UniversityAPIService: BaseAPIService, UniversityAPIServiceProtocol {
    private let provider = MoyaProvider<UniversityTargetType>(plugins: [MoyaPlugin()])
    
    func getUniversityList(completion: @escaping (NetworkResult<BaseDTO<GetUniversityListResponseDataDTO>>) -> Void) {
        provider.request(.getUniversityList) { result in
            switch result{
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<GetUniversityListResponseDataDTO>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                //                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<GetUniversityListResponseDataDTO>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}
