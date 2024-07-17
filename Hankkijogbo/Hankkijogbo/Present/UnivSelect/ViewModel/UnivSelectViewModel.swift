//
//  UnivSelectViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import Foundation

class UnivSelectViewModel {
    
    var currentUniv: String = ""
    
    var universityList: [GetUniversityResponseData] = [] {
        didSet {
            self.reloadCollectionView?()
        }
    }
    
    var reloadCollectionView: (() -> Void)?
    var currentSelectedUniversity: String = ""
    

    
    
}

extension UnivSelectViewModel {
    func getUniversityList(completion: @escaping (Bool) -> Void) {
        NetworkService.shared.universityService.getUniversityList { [weak self] result in
            switch result {
            case .success(let response):
                self?.universityList = response?.data.universities ?? []
                completion(true)
            case .unAuthorized, .networkFail:
                print("Failed to fetch university list.")
                completion(false)
            default:
                completion(false)
            }
        }
    }
}
