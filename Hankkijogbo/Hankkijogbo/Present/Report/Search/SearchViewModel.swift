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
    private let locationAPIService: LocationAPIServiceProtocol

    var model: GetSearchedLocationResponseData? {
        didSet {
            updateLocations?()
        }
    }
    var updateLocations: (() -> Void)?
    
    init(locationAPIService: LocationAPIServiceProtocol = LocationAPIService()) {
        self.locationAPIService = locationAPIService
    }
    
    func removeAllLocations() {
        model?.locations.removeAll()
    }

    func getSearchedLocationAPI(query: String) {
        NetworkService.shared.locationService.getSearchedLocation(query: query) { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = response?.data else { return }
                self?.model = data
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
