//
//  MenuAPIService.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/8/24.
//

import Foundation

import Moya

protocol MenuAPIServiceProtocol {
    
    typealias MenuResponseDTO = BaseDTO<MenuResponseData>
    
    func getMenu(storeId: Int, completion: @escaping(NetworkResult<MenuResponseDTO>) -> Void)
    func postMenu(storeId: Int, requestBody: [MenuRequestDTO], completion: @escaping(NetworkResult<MenuResponseDTO>) -> Void)
    func patchMenu(storeId: Int, id: Int, requestBody: MenuRequestDTO, completion: @escaping(NetworkResult<EmptyDTO>) -> Void)
    func deleteMenu(storeId: Int, id: Int, completion: @escaping(NetworkResult<Void>) -> Void)
}

final class MenuAPIService: BaseAPIService, MenuAPIServiceProtocol {
    
    private let provider = MoyaProvider<MenuTargetType>(plugins: [MoyaPlugin.shared])
    
    func getMenu(storeId: Int, completion: @escaping (NetworkResult<MenuResponseDTO>) -> Void) {
        provider.request(.getMenu(storeId: storeId)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<MenuResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<MenuResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func postMenu(
        storeId: Int,
        requestBody: [MenuRequestDTO],
        completion: @escaping (NetworkResult<MenuResponseDTO>) -> Void
    ) {
        provider.request(.postMenu(storeId: storeId, requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<MenuResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<MenuResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func patchMenu(
        storeId: Int,
        id: Int,
        requestBody: MenuRequestDTO,
        completion: @escaping (NetworkResult<EmptyDTO>) -> Void
    ) {
        provider.request(.patchMenu(storeId: storeId, id: id, requestBody: requestBody)) { result in
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
    
    func deleteMenu(storeId: Int, id: Int, completion: @escaping (NetworkResult<Void>) -> Void) {
        provider.request(.deleteMenu(storeId: storeId, id: id)) { result in
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
}
