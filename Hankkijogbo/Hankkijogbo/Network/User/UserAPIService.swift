//
//  UserAPIService.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

import Moya

protocol UserAPIServiceProtocol {
    typealias GetMeResponseDTO = BaseDTO<GetMeResponseData>
    typealias GetMeHankkiListResponseDTO = BaseDTO<GetMeHankkiListResponseData>
    typealias GetMeZipListResponseDTO = BaseDTO<GetMeZipListResponseData>
    typealias GetMeUniversityResponseDTO = BaseDTO<GetMeUniversityResponseData>
    
    func getMe(completion: @escaping(NetworkResult<GetMeResponseDTO>) -> Void)
    func getMeHankkiList(_ type: UserTargetType, completion: @escaping(NetworkResult<GetMeHankkiListResponseDTO>) -> Void)
    func getMeZipList(completion: @escaping (NetworkResult<GetMeZipListResponseDTO>) -> Void)
    func postMeUniversity(requestBody: PostMeUniversityRequestDTO, completion: @escaping (NetworkResult<EmptyDTO>) -> Void)
    func getMeUniversity(completion: @escaping (NetworkResult<GetMeUniversityResponseDTO>) -> Void)
}

final class UserAPIService: BaseAPIService, UserAPIServiceProtocol {
    
    private let provider = MoyaProvider<UserTargetType>(plugins: [MoyaPlugin()])
    
    func getMe(completion: @escaping (NetworkResult<GetMeResponseDTO>) -> Void) {
        provider.request(.getMe) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetMeResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetMeResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func getMeHankkiList(_ type: UserTargetType, completion: @escaping (NetworkResult<GetMeHankkiListResponseDTO>) -> Void) {
        provider.request(type) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetMeHankkiListResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetMeHankkiListResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func getMeZipList(completion: @escaping (NetworkResult<GetMeZipListResponseDTO>) -> Void) {
        provider.request(.getMeZipList) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetMeZipListResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetMeZipListResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func postMeUniversity(requestBody: PostMeUniversityRequestDTO, completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
        provider.request(.postMeUniversity(requestBody: requestBody)) { result in
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
    
    func getMeUniversity(completion: @escaping (NetworkResult<GetMeUniversityResponseDTO>) -> Void) {
        provider.request(.getMeUniversity) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetMeUniversityResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetMeUniversityResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}
