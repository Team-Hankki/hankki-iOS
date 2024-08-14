//
//  HakkiAPIService.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation
import Moya

protocol HankkiAPIServiceProtocol {
    func getCategoryFilter(completion: @escaping(NetworkResult<GetCategoryFilterResponseDTO>) -> Void)
    func getPriceCategoryFilter(completion: @escaping(NetworkResult<GetPriceFilterResponseDTO>) -> Void)
    func getSortOptionFilter(completion: @escaping(NetworkResult<GetSortOptionFilterResponseDTO>) -> Void)
    func getHankkiList(universityId: Int, storeCategory: String, priceCategory: String, sortOption: String, completion: @escaping(NetworkResult<GetHankkiListResponseDTO>) -> Void)
    func getHankkiPin(universityId: Int, storeCategory: String, priceCategory: String, sortOption: String, completion: @escaping(NetworkResult<GetHankkiPinResponseDTO>) -> Void)
    func getHankkiThumbnail(id: Int, completion: @escaping(NetworkResult<GetHankkiThumbnailResponseDTO>) -> Void)
    func getHankkiDetail(id: Int, completion: @escaping(NetworkResult<GetHankkiDetailResponseDTO>) -> Void)
    func postHankkiValidate(req: PostHankkiValidateRequestDTO, completion: @escaping(NetworkResult<PostHankkiValidateResponseDTO>) -> Void)
    func postHankkiHeart(id: Int, completion: @escaping(NetworkResult<HeartResponseDTO>) -> Void)
    func postHankki(multipartData: [MultipartFormData], completion: @escaping(NetworkResult<PostHankkiResponseDTO>) -> Void)
    func postHankkiFromOther(request: PostHankkiFromOtherRequestDTO, completion: @escaping(NetworkResult<EmptyDTO>) -> Void)
    func deleteHankkiHeart(id: Int, completion: @escaping(NetworkResult<HeartResponseDTO>) -> Void)
    func deleteHankki(id: Int, completion: @escaping(NetworkResult<Void>) -> Void)
}

extension HankkiAPIServiceProtocol {
    typealias GetCategoryFilterResponseDTO = BaseDTO<GetCategoryFilterResponseData>
    typealias GetPriceFilterResponseDTO = BaseDTO<GetPriceFilterResponseData>
    typealias GetSortOptionFilterResponseDTO = BaseDTO<GetSortOptionFilterResponseData>
    typealias GetHankkiListResponseDTO = BaseDTO<GetHankkiListResponseData>
    typealias GetHankkiPinResponseDTO = BaseDTO<GetHankkiPinResponseData>
    typealias GetHankkiThumbnailResponseDTO = BaseDTO<GetHankkiThumbnailResponseData>
    typealias GetHankkiDetailResponseDTO = BaseDTO<GetHankkiDetailResponseData>
    typealias HeartResponseDTO = BaseDTO<HeartResponseData>
    typealias PostHankkiValidateResponseDTO = BaseDTO<PostHankkiValidateResponseData>
    typealias PostHankkiResponseDTO = BaseDTO<PostHankkiResponseData>
}

final class HankkiAPIService: BaseAPIService, HankkiAPIServiceProtocol {
    
    private let provider = MoyaProvider<HankkiTargetType>(plugins: [MoyaPlugin()])
    
    func postHankki(multipartData: [MultipartFormData], completion: @escaping (NetworkResult<PostHankkiResponseDTO>) -> Void) {
        provider.request(.postHankki(multipartData: multipartData)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PostHankkiResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<PostHankkiResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 카테고리 필터 드롭다운 정보 조회
    func getCategoryFilter(completion: @escaping (NetworkResult<GetCategoryFilterResponseDTO>) -> Void) {
        provider.request(.getCategoryFilter) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetCategoryFilterResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetCategoryFilterResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 가격 필터 드롭다운 정보 조회
    func getPriceCategoryFilter(completion: @escaping (NetworkResult<GetPriceFilterResponseDTO>) -> Void) {
        provider.request(.getPriceCategoryFilter) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetPriceFilterResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetPriceFilterResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 정렬 드롭다운 정보 조회
    func getSortOptionFilter(completion: @escaping (NetworkResult<GetSortOptionFilterResponseDTO>) -> Void) {
        provider.request(.getSortOptionFilter) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetSortOptionFilterResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetSortOptionFilterResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 이미 등록된 식당인지 판별
    func postHankkiValidate(req: PostHankkiValidateRequestDTO, completion: @escaping (NetworkResult<PostHankkiValidateResponseDTO>) -> Void) {
        provider.request(.postHankkiValidate(req: req)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PostHankkiValidateResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<PostHankkiValidateResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
  
    /// 메인 페이지 식당 리스트 조회
    func getHankkiList(universityId: Int, storeCategory: String, priceCategory: String, sortOption: String, completion: @escaping (NetworkResult<GetHankkiListResponseDTO>) -> Void) {
        provider.request(.getHankkiList(universityid: universityId, storeCategory: storeCategory, priceCategory: priceCategory, sortOption: sortOption)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetHankkiListResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetHankkiListResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 메인 페이지 식당 핀 조회
    func getHankkiPin(universityId: Int, storeCategory: String, priceCategory: String, sortOption: String, completion: @escaping (NetworkResult<GetHankkiPinResponseDTO>) -> Void) {
        provider.request(.getHankkiPin(universityId: universityId, storeCategory: storeCategory, priceCategory: priceCategory, sortOption: sortOption)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetHankkiPinResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetHankkiPinResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    /// 식당 썸네일 조회 
    func getHankkiThumbnail(id: Int, completion: @escaping (NetworkResult<GetHankkiThumbnailResponseDTO>) -> Void) {
        provider.request(.getHankkiThumbnail(id: id)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetHankkiThumbnailResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetHankkiThumbnailResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
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
    func postHankkiHeart(id: Int, completion: @escaping (NetworkResult<HeartResponseDTO>) -> Void) {
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
    func deleteHankkiHeart(id: Int, completion: @escaping (NetworkResult<HeartResponseDTO>) -> Void) {
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
    
    /// 타학교에 있던 식당 우리 학교에도 제보하기
    func postHankkiFromOther(request: PostHankkiFromOtherRequestDTO, completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
        provider.request(.postHankkiFromOther(request: request)) { result in
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
    
    /// 식당 삭제하기
    func deleteHankki(id: Int, completion: @escaping (NetworkResult<Void>) -> Void) {
        provider.request(.deleteHankki(id: id)) { result in
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
