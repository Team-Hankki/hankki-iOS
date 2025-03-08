//
//  NaverMapAPIService.swift
//  Hankkijogbo
//
//  Created by 서은수 on 12/30/24.
//

import Foundation

import Moya

protocol NaverMapAPIServiceProtocol {
    func getHankkiAddress(latitude: Double, longitude: Double, completion: @escaping(NetworkResult<GetHankkiAddressResponseDTO>) -> Void)
}

final class NaverMapAPIService: BaseAPIService, NaverMapAPIServiceProtocol {
    
    private let provider = MoyaProvider<NaverMapTargetType>(plugins: [MoyaPlugin.shared])
    
    func getHankkiAddress(
        latitude: Double,
        longitude: Double,
        completion: @escaping (NetworkResult<GetHankkiAddressResponseDTO>) -> Void) {
        provider.request(.getHankkiAddress(latitude: latitude, longitude: longitude)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetHankkiAddressResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetHankkiAddressResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}
