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
    var showAlertToMove: (() -> Void)?
    var showAlertToAdd: (() -> Void)?
    var completeLocationSelection: (() -> Void)?
    
    var selectedLocationData: GetSearchedLocation? {
        didSet {
            selectLocation?()
        }
    }
    var searchedLocationResponseData: GetSearchedLocationResponseData? {
        didSet {
            updateLocations?()
        }
    }
    var updateLocations: (() -> Void)?
    var selectLocation: (() -> Void)?
    var emptyResult: (() -> Void)?
}

extension SearchViewModel {
    func removeAllLocations() {
        searchedLocationResponseData?.locations.removeAll()
    }

    func getSearchedLocationAPI(query: String) {
        NetworkService.shared.locationService.getSearchedLocation(query: query) { result in
            result.handleNetworkResult { [weak self] response in
                self?.searchedLocationResponseData = response.data
            }
        }
    }
    
    func postHankkiValidateAPI(req: PostHankkiValidateRequestDTO) {
        NetworkService.shared.hankkiService.postHankkiValidate(req: req) { result in
            result.handleNetworkResult { [weak self] response in
                let data = response.data
                if data.id == nil {
                    self?.completeLocationSelection?()
                } else {
                    if data.isRegistered {
                        self?.showAlertToMove?()
                    } else {
                        self?.showAlertToAdd?()
                    }
                }
            }
        }
    }
}
