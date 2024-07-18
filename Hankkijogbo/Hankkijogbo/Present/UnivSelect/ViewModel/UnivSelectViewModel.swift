//
//  UnivSelectViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import Foundation

class UnivSelectViewModel {
    
    var currentUniv: String = ""
    
    var universityList: [GetUniversityListData] = [] {
        didSet {
            self.reloadCollectionView?()
        }
    }
    
    var reloadCollectionView: (() -> Void)?
    var currentSelectedUniversity: String = ""
}

extension UnivSelectViewModel {
    func getUniversityList() {
        NetworkService.shared.universityService.getUniversityList { [weak self] result in
            switch result {
            case .success(let response):
                self?.universityList = response?.data.universities ?? []
//                completion(true)
            case .unAuthorized, .networkFail:
                print("Failed to fetch university list.")
//                completion(false)
            default:
                return
//                completion(false)
            }
        }
    }
}
