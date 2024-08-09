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
    var showAlert: ((String, String?, String) -> Void)?
    var completeLocationSelection: (() -> Void)?
    
    var selectedLocationData: GetSearchedLocation?
    var searchedLocationResponseData: GetSearchedLocationResponseData? {
        didSet {
            updateLocations?()
        }
    }
    var updateLocations: (() -> Void)?
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
            switch result {
            case .conflict:
                self.showAlert?(StringLiterals.Alert.alreadyReportHankki, nil, StringLiterals.Alert.check)
            default:
                result.handleNetworkResult { _ in
                    self.completeLocationSelection?()
                }
            }
        }
    }
}
