//
//  ReportAPIService.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/17/24.
//

import Foundation

import Moya

protocol ReportAPIServiceProtocol {
    typealias GetReportedNumberResponseDTO = BaseDTO<GetReportedNumberResponseData>
    func getReportedNumber(completion: @escaping(NetworkResult<GetReportedNumberResponseDTO>) -> Void)
}

final class ReportAPIService: BaseAPIService, ReportAPIServiceProtocol {
    
    private let provider = MoyaProvider<ReportTargetType>(plugins: [MoyaPlugin()])
    
    
    func getReportedNumber(completion: @escaping (NetworkResult<GetReportedNumberResponseDTO>) -> Void) {
        provider.request(.getReportedNumber) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetReportedNumberResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetReportedNumberResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}
