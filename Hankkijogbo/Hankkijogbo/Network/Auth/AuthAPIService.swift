//
//  AuthAPIService.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/16/24.
//

import Foundation

import Moya

protocol AuthAPIServiceProtocol {
    typealias PostLoginResponseDTO = BaseDTO<PostLoginResponseData>
    typealias PostReissueResponseDTO = BaseDTO<PostReissueResponseData>
    
    func postLogin(accessToken: String, requestBody: PostLoginRequestDTO, completion: @escaping(NetworkResult<PostLoginResponseDTO>) -> Void)
    func patchLogout(completion: @escaping(NetworkResult<EmptyDTO>) -> Void)
    func deleteWithdraw(authorizationCode: String, completion: @escaping(NetworkResult<EmptyDTO>) -> Void)
    func postReissue(completion: @escaping(NetworkResult<PostReissueResponseDTO>) -> Void)
}

final class AuthAPIService: BaseAPIService, AuthAPIServiceProtocol {
    
    private let provider = MoyaProvider<AuthTargetType>(plugins: [MoyaPlugin()])
    
    func postLogin(accessToken: String, requestBody: PostLoginRequestDTO, completion: @escaping (NetworkResult<PostLoginResponseDTO>) -> Void) {
        provider.request(.postLogin(accessToken: accessToken, requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PostLoginResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<PostLoginResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
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
    
    func deleteWithdraw(authorizationCode: String, completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
        provider.request(.deleteWithdraw(authorizationCode: authorizationCode)) { result in
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
    
    func postReissue(completion: @escaping (NetworkResult<PostReissueResponseDTO>) -> Void) {
        provider.request(.postReissue) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PostReissueResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<PostReissueResponseData> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                }
            }
        }
    }
}
