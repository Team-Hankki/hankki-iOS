//
//  ZipAPIService.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

import Moya

protocol ZipAPIServiceProtocol {
    func getZipList(zipId: Int, completion: @escaping(NetworkResult<BaseDTO<GetZipDetailResponseData>>) -> Void)
}

final class ZipAPIService: BaseAPIService, ZipAPIServiceProtocol {
    
    private let provider = MoyaProvider<ZipTargetType>(plugins: [MoyaPlugin()])

    func getZipList(zipId: Int, completion: @escaping (NetworkResult<BaseDTO<GetZipDetailResponseData>>) -> Void) {
        provider.request(.getZipDetail(zipId: zipId)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<GetZipDetailResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<GetZipDetailResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}
