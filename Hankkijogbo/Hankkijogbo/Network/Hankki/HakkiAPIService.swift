//
//  HakkiAPIService.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation
import Moya

protocol HankkiAPIServiceProtocol {
    func getCategoryFilter(completion: @escaping(NetworkResult<BaseDTO<GetCategoryFilterResponseData>>) -> Void)
    func getPriceCategoryFilter(completion: @escaping(NetworkResult<BaseDTO<GetPriceFilterResponseData>>) -> Void)
    func getSortOptionFilter(completion: @escaping(NetworkResult<BaseDTO<GetSortOptionFilterResponseData>>) -> Void)
    func getHankkiList(universityid: Int, storeCategory: String, priceCategory: String, sortOption: String, completion: @escaping(NetworkResult<BaseDTO<GetHankkiListResponseData>>) -> Void)
    func getHankkiPin(universityId: Int, storeCategory: String, priceCategory: String, sortOption: String, completion: @escaping(NetworkResult<BaseDTO<GetHankkiPinResponseData>>) -> Void)
    func getHankkiThumbnail(id: Int, completion: @escaping(NetworkResult<BaseDTO<GetHankkiThumbnailResponseData>>) -> Void)
    func getHankkiDetail(id: Int, completion: @escaping(NetworkResult<GetHankkiDetailResponseDTO>) -> Void)
    func postHankkiValidate(req: PostHankkiValidateRequestDTO, completion: @escaping(NetworkResult<EmptyDTO>) -> Void)
    func postHankkiHeart(id: Int64, completion: @escaping(NetworkResult<HeartResponseDTO>) -> Void)
    func deleteHankkiHeart(id: Int64, completion: @escaping(NetworkResult<HeartResponseDTO>) -> Void)
}

extension HankkiAPIServiceProtocol {
    typealias GetHankkiDetailResponseDTO = BaseDTO<GetHankkiDetailResponseData>
    typealias HeartResponseDTO = BaseDTO<HeartResponseData>
}

final class HankkiAPIService: BaseAPIService, HankkiAPIServiceProtocol {
    
    private let provider = MoyaProvider<HankkiTargetType>(plugins: [MoyaPlugin()])
    
    /// 카테고리 필터 드롭다운 정보 조회
    func getCategoryFilter(completion: @escaping (NetworkResult<BaseDTO<GetCategoryFilterResponseData>>) -> Void) {
        provider.request(.getCategoryFilter) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<GetCategoryFilterResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<GetCategoryFilterResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 가격 필터 드롭다운 정보 조회
    func getPriceCategoryFilter(completion: @escaping (NetworkResult<BaseDTO<GetPriceFilterResponseData>>) -> Void) {
        provider.request(.getPriceCategoryFilter) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<GetPriceFilterResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<GetPriceFilterResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 정렬 드롭다운 정보 조회
    func getSortOptionFilter(completion: @escaping (NetworkResult<BaseDTO<GetSortOptionFilterResponseData>>) -> Void) {
        provider.request(.getSortOptionFilter) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<GetSortOptionFilterResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<GetSortOptionFilterResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 이미 등록된 식당인지 판별
    func postHankkiValidate(req: PostHankkiValidateRequestDTO, completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
        provider.request(.postHankkiValidate(req: req)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<EmptyDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
  
    /// 메인 페이지 식당 리스트 조회
    func getHankkiList(universityid: Int, storeCategory: String, priceCategory: String, sortOption: String, completion: @escaping (NetworkResult<BaseDTO<GetHankkiListResponseData>>) -> Void) {
        provider.request(.getHankkiList(universityid: universityid, storeCategory: storeCategory, priceCategory: priceCategory, sortOption: sortOption)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<GetHankkiListResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<GetHankkiListResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 메인 페이지 식당 핀 조회
    func getHankkiPin(universityId: Int, storeCategory: String, priceCategory: String, sortOption: String, completion: @escaping (NetworkResult<BaseDTO<GetHankkiPinResponseData>>) -> Void) {
        provider.request(.getHankkiPin(universityId: universityId, storeCategory: storeCategory, priceCategory: priceCategory, sortOption: sortOption)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<GetHankkiPinResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<GetHankkiPinResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 식당 썸네일 조회 
    func getHankkiThumbnail(id: Int, completion: @escaping (NetworkResult<BaseDTO<GetHankkiThumbnailResponseData>>) -> Void) {
        provider.request(.getHankkiThumbnail(id: id)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<GetHankkiThumbnailResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<GetHankkiThumbnailResponseData>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    /// 식당 세부 조회
    func getHankkiDetail(id: Int, completion: @escaping (NetworkResult<GetHankkiDetailResponseDTO>) -> Void) {
        provider.request(.getHankkiDetail(id: id)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetHankkiDetailResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetHankkiDetailResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 식당 좋아요 추가
    func postHankkiHeart(id: Int64, completion: @escaping (NetworkResult<HeartResponseDTO>) -> Void) {
        provider.request(.postHankkiHeart(id: id)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<HeartResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<HeartResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 식당 좋아요 취소
    func deleteHankkiHeart(id: Int64, completion: @escaping (NetworkResult<HeartResponseDTO>) -> Void) {
        provider.request(.deleteHankkiHeart(id: id)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<HeartResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<HeartResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}
