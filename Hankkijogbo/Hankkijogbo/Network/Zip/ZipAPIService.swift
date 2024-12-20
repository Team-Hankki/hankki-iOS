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
    typealias GetZipDetailResponseDTO = BaseDTO<GetZipDetailResponseData>
    
    func getMyZipList(id: Int, completion: @escaping(NetworkResult<GetMyZipListResponseDTO>) -> Void)
    func getZipList(zipId: Int, completion: @escaping(NetworkResult<GetZipDetailResponseDTO>) -> Void)
    func postZipBatchDelete(requesBody: PostZipBatchDeleteRequestDTO, completion: @escaping(NetworkResult<Void>) -> Void)
    func postZip(requestBody: PostZipRequestDTO, completion: @escaping (NetworkResult<EmptyDTO>) -> Void)
    func postSharedZip(zipId: Int, requestBody: PostZipRequestDTO, completion: @escaping (NetworkResult<EmptyDTO>) -> Void)
    func deleteZipToHankki(requestBody: DeleteZipToHankkiRequestDTO, completion: @escaping (NetworkResult<Void>) -> Void)
    func postHankkiToZip(requestBody: PostHankkiToZipRequestDTO, completion: @escaping(NetworkResult<EmptyDTO>) -> Void)
}

final class ZipAPIService: BaseAPIService, ZipAPIServiceProtocol {

    private let provider = MoyaProvider<ZipTargetType>(plugins: [MoyaPlugin.shared])
    
    func deleteZipToHankki(requestBody: DeleteZipToHankkiRequestDTO, completion: @escaping (NetworkResult<Void>) -> Void) {
        provider.request(.deleteZipToHankki(requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<Void> = self.fetchNetworkResult(statusCode: response.statusCode)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<Void> = self.fetchNetworkResult(statusCode: response.statusCode)
                    completion(networkResult)
                }
            }
        }
    }

    func getMyZipList(id: Int, completion: @escaping (NetworkResult<GetMyZipListResponseDTO>) -> Void) {
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
    
    func getZipList(zipId: Int, completion: @escaping (NetworkResult<GetZipDetailResponseDTO>) -> Void) {
        provider.request(.getZipDetail(zipId: zipId)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetZipDetailResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetZipDetailResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func postZipBatchDelete(requesBody: PostZipBatchDeleteRequestDTO, completion: @escaping (NetworkResult<Void>) -> Void) {
        provider.request(.postZipBatchDelete(requestBody: requesBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<Void> = self.fetchNetworkResult(statusCode: response.statusCode)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<Void> = self.fetchNetworkResult(statusCode: response.statusCode)
                    completion(networkResult)
                }
            }
        }
    }
    
    func postZip(requestBody: PostZipRequestDTO, completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
        provider.request(.postZip(requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<EmptyDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func postSharedZip(zipId: Int, requestBody: PostZipRequestDTO, completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
        provider.request(.postSharedZip(zipId: zipId, requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<EmptyDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 족보에 식당 추가
    func postHankkiToZip(requestBody: PostHankkiToZipRequestDTO, completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
        provider.request(.postHankkiToZip(requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
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
