//
//  LocationAPIService.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/17/24.
//

import Foundation

import Moya

protocol LocationAPIServiceProtocol {
    typealias GetSearchedLocationResponseDTO = BaseDTO<GetSearchedLocationResponseData>
    func getSearchedLocation(query: String, completion: @escaping(NetworkResult<GetSearchedLocationResponseDTO>) -> Void)
}

final class LocationAPIService: BaseAPIService, LocationAPIServiceProtocol {
    
    private let provider = MoyaProvider<LocationTargetType>(plugins: [MoyaPlugin()])
    
    func getSearchedLocation(query: String, completion: @escaping (NetworkResult<GetSearchedLocationResponseDTO>) -> Void) {
        provider.request(.getSearchedLocation(query: query)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetSearchedLocationResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetSearchedLocationResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}
