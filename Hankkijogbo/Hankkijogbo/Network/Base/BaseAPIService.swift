//
//  BaseAPIService.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation

class BaseAPIService {
    
    /// 200 받았을 때 decoding 할 데이터가 있는 경우 (대부분의 GET)
    func fetchNetworkResult<T: Decodable>(statusCode: Int, data: Data) -> NetworkResult<T> {
        switch statusCode {
        case 200, 201, 204:
            if let decodedData = fetchDecodeData(data: data, responseType: T.self) {
                return .success(decodedData)
            } else { return .decodeErr }
        case 400: return .badRequest
        case 401: return .unAuthorized
        case 404: return .notFound
        case 422: return .unProcessable
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    /// 200 받았을 때 decoding 할 데이터가 없는 경우 (대부분의 PATCH, PUT, DELETE)
    func fetchNetworkResult(statusCode: Int, data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200, 201, 204: return .success(nil)
        case 400: return .badRequest
        case 401: return .unAuthorized
        case 404: return .notFound
        case 422: return .unProcessable
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    /// API를 통해 받아온 Data를 T Type 형태로 Decode하는 함수
    func fetchDecodeData<T: Decodable>(data: Data, responseType: T.Type) -> T? {
        let decoder = JSONDecoder()
        
        if let decodedData = try? decoder.decode(responseType, from: data) {
            return decodedData
        } else { return nil }
    }
}
