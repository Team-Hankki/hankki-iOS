//
//  UserAPIService.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

import Moya

protocol UserAPIServiceProtocol {
    func getMe(completion: @escaping(NetworkResult<BaseDTO<GetMeResponseData>>) -> Void)
    func getMeHankkiList(_ type: UserTargetType, completion: @escaping(NetworkResult<BaseDTO<GetMeHankkiListResponseData>>) -> Void)
    func getMeZipList(completion: @escaping (NetworkResult<BaseDTO<GetMeZipListResponseData>>) -> Void)
    func postMeUniversity(requestBody: PostMeUniversityRequestDTO, completion: @escaping (NetworkResult<EmptyDTO>)-> Void)
    func getMeUniversity(completion: @escaping (NetworkResult<GetMeUniversityResponseData>) -> Void)
}

final class UserAPIService: BaseAPIService, UserAPIServiceProtocol {
    
    private let provider = MoyaProvider<UserTargetType>(plugins: [MoyaPlugin()])
    
    func getMe(completion: @escaping (NetworkResult<BaseDTO<GetMeResponseData>>) -> Void) {
        provider.request(.getMe) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<GetMeResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<GetMeResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func getMeHankkiList(_ type: UserTargetType, completion: @escaping (NetworkResult<BaseDTO<GetMeHankkiListResponseData>>) -> Void) {
        provider.request(type) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<GetMeHankkiListResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<GetMeHankkiListResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func getMeZipList(completion: @escaping (NetworkResult<BaseDTO<GetMeZipListResponseData>>) -> Void) {
        provider.request(.getMeZipList) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<GetMeZipListResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<GetMeZipListResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
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
    
    func getMeUniversity(completion: @escaping (NetworkResult<GetMeUniversityResponseData>) -> Void) {
        provider.request(.getMeUniversity) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetMeUniversityResponseData> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetMeUniversityResponseData> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}
