//
//  SearchViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/17/24.
//

import Foundation

import Moya

// MARK: - 장소 검색 API 연동

final class SearchViewModel {
    
    var selectedLocationData: GetSearchedLocation?
    var searchedLocationResponseData: GetSearchedLocationResponseData? {
        didSet {
            updateLocations?()
        }
    }
    var updateLocations: (() -> Void)?
    var postHankkiValidateCode: Int? {
        didSet {
            completeLocationSelection?()
        }
    }
    var completeLocationSelection: (() -> Void)?
    
    func removeAllLocations() {
        searchedLocationResponseData?.locations.removeAll()
    }

    func getSearchedLocationAPI(query: String) {
        NetworkService.shared.locationService.getSearchedLocation(query: query) { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = response?.data else { return }
                self?.searchedLocationResponseData = data
            case .badRequest, .unAuthorized:
                print("badRequest")
            case .serverError:
                print("serverError")
            default:
                return
            }
        }
    }
    
    func postHankkiValidateAPI(req: PostHankkiValidateRequestDTO) {
        NetworkService.shared.hankkiService.postHankkiValidate(req: req) { [weak self] result in
            switch result {
            case .success(let response):
                self?.postHankkiValidateCode = response?.code
            case .badRequest, .unAuthorized:
                print("badRequest")
            case .serverError:
                print("serverError")
            default:
                return
            }
        }
    }
}
