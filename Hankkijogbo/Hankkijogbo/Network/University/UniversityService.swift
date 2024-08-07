//
//  UniversityService.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

import Moya

protocol UniversityAPIServiceProtocol {
    typealias GetUniversityListResponseDTO = BaseDTO<GetUniversityListResponseData>
    func getUniversityList(completion: @escaping(NetworkResult<GetUniversityListResponseDTO>) -> Void)
}

final class UniversityAPIService: BaseAPIService, UniversityAPIServiceProtocol {
    private let provider = MoyaProvider<UniversityTargetType>(plugins: [MoyaPlugin()])
    
    func getUniversityList(completion: @escaping (NetworkResult<GetUniversityListResponseDTO>) -> Void) {
        provider.request(.getUniversityList) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetUniversityListResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetUniversityListResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}
