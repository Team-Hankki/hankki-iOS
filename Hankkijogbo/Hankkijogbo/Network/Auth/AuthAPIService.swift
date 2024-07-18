//
//  AuthAPIService.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/16/24.
//

import Foundation

import Moya

protocol AuthAPIServiceProtocol {
    func postLogin(requestBody: PostLoginRequestDTO, completion: @escaping(NetworkResult<BaseDTO<PostLoginResponseData>>) -> Void)
    func patchLogout(completion: @escaping(NetworkResult<EmptyDTO>) -> Void)
}

final class AuthAPIService: BaseAPIService, AuthAPIServiceProtocol {
    
    private let provider = MoyaProvider<AuthTargetType>(plugins: [MoyaPlugin()])
    
    func postLogin(requestBody: PostLoginRequestDTO, completion: @escaping (NetworkResult<BaseDTO<PostLoginResponseData>>) -> Void) {
        provider.request(.postLogin(requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<PostLoginResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<PostLoginResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func patchLogout(completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
        provider.request(.patchLogout) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
//                print(networkResult.stateDescription)
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
