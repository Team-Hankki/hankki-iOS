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
    
    var isFinalSelected: Bool = false
    var storeId: Int?
    private var universityId: Int?
    
    var showAlertToMove: (() -> Void)?
    var showAlertToAdd: (() -> Void)?
    var completeLocationSelection: (() -> Void)?
    var moveToDetail: (() -> Void)?
    
    var selectedLocationData: GetSearchedLocation?
    var searchedLocationResponseData: GetSearchedLocationResponseData? {
        didSet {
            updateLocations?()
        }
    }
    var updateLocations: (() -> Void)?
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
                    self?.isFinalSelected = true
                    self?.completeLocationSelection?()
                } else {
                    self?.storeId = data.id
                    if data.isRegistered {
                        self?.showAlertToMove?()
                    } else {
                        self?.universityId = req.universityId
                        self?.showAlertToAdd?()
                    }
                }
            }
        }
    }
    
    func postHankkiFromOtherAPI() {
        guard let storeId = storeId else { return }
        guard let universityId = universityId else { return }
        let request = PostHankkiFromOtherRequestDTO(storeId: storeId, universityId: universityId)
        NetworkService.shared.hankkiService.postHankkiFromOther(request: request) { result in
            result.handleNetworkResult { _ in
                self.moveToDetail?()
            }
        }
    }
}
