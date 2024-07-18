//
//  ZipAPIService.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

import Moya

protocol ZipAPIServiceProtocol {
    typealias GetMyZipListResponseDTO = BaseDTO<GetMyZipListResponseData>
    
    func getMyZipList(id: Double, completion: @escaping(NetworkResult<GetMyZipListResponseDTO>) -> Void)
}

final class ZipAPIService: BaseAPIService, ZipAPIServiceProtocol {
    
    private let provider = MoyaProvider<ZipTargetType>(plugins: [MoyaPlugin()])

    func getMyZipList(id: Double, completion: @escaping (NetworkResult<GetMyZipListResponseDTO>) -> Void) {
        provider.request(.getMyZipList(id: id)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetMyZipListResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetMyZipListResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}
